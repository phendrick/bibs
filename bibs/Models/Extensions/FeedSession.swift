//
//  FeedSession+Timers.swift
//  bibs
//
//  Created by Paul Hendrick on 26/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import CoreData

extension FeedSession: Identifiable, Trackable {
    public enum FeedSessionStatus: Int16, CaseIterable {
        case paused    // manually paused by user
        case running   // incrementing feed duration value
        case complete  // is an old feed session
        case suspended // suspended when user backgrounds the app
    }
    
    enum FeedSessionError: Error {
        case noCurrentFeed
    }
    
    public var status: FeedSessionStatus {
        get {
            FeedSessionStatus.init(rawValue: self.state) ?? .paused
        }
        
        set(newValue) {
            state = newValue.rawValue
        }
    }
    
    var isActiveFeedSession: Bool {
        status == .running
    }
    
    var currentFeed: Feed? {
        return feedsArray.last
    }
    
    var currentBreastSide: Feed.BreastSide? {
        return currentFeed?.breastSide
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
    
    /// turn our .feeds associated set into an array by sorting the members
    public var feedsArray: [Feed] {
        let set = feeds as? Set<Feed> ?? []
        return set.sorted {$0.wrappedCreatedAt < $1.wrappedCreatedAt}
    }
    
    /// aggregate duration of all the associated feed instances
    var duration: Int32 {
        return feedsArray.reduce(into: 0) { (total, feed) in
            total += feed.duration
        }
    }
    
    /// a tuple of the elaped time components
    var calculatedElapsedTime: (hours: Int, minutes: Int, seconds: Int, hseconds: Int) {
        let hours    = Int((duration / 100) / 3600)
        let minutes  = Int((duration / 100) / 60 % 60)
        let seconds  = Int((duration / 100 ) % 60)
        let hseconds = Int((duration % 100))
        
        return (hours: hours, minutes: minutes, seconds: seconds, hseconds: hseconds)
    }
    
    /// formatted string to render the elapsed time
    func formattedElapsedTime(include_hsec: Bool = true) -> String {
        var time = String(format:"%02i:%02i:%02i", calculatedElapsedTime.hours, calculatedElapsedTime.minutes, calculatedElapsedTime.seconds)
        
        if include_hsec {
            time.append(contentsOf: String(format: ".%02i", calculatedElapsedTime.hseconds))
        }
        
        return time
    }
    
    /// a basic timer implementation.
    /// the timer stops incrementing and invalidate's itself when the current timer `.status` is set to `.paused`, so
    /// we can call `feedSession.pause()` or  `feedSession.setStatus(to: .paused)` to stop a timer
    var timer: Timer {
        Timer(timeInterval: 0.01, repeats: true) { (timer) in
            guard let feed = self.currentFeed else {
                timer.invalidate()
                return
            }
            
            if self.status != .running {
                timer.invalidate()
            }
            
            feed.duration += 1
            self.objectWillChange.send()
        }
    }
    
    /// MARK: public api for controlling sessions
    func pause() {
        guard status == .running || status == .suspended else {
            print("Can't pause a non-running session")
            return
        }
        
        self.status = .paused
        self.timer.invalidate()
    }
    
    /// save a session to be resumed later
    /// if `hibernate` is set to true, we dont invalidate the timer as we may still only be in preview mode, not fully switched to the background
    func suspend() {
        guard status == .running else {
            print("Can't suspend a non-running session")
            return
        }
        
        self.suspendedAt = Date()
        self.status = .suspended
        timer.invalidate()
    }
    
    func resume(force fromSuspension: Bool = false) {
        /// guard against calling .fire() on an already .running timer since we'll be incrememnting the duration for each fired timer
        /// unless the timer is being resumed from suspension, inwhich case its timer will be invalid and needs to be re-fired
        guard status != .running else {
            print("not re-firing timer")
            return
        }
        
//        let forcedResumption = fromSuspension == true && status == .running
//
//        if status != .running || forcedResumption {
//            print("Timer wasn't running, or forced to resume: \(status), \(forcedResumption")
//            return
//        }
//
//        if status == .running && fromSuspension == true {
//            print("force resumption from suspension")
//        }
//
//        print(fromSuspension, status)
//        print("Setting status to .running and firing timer")
        
        self.status = .running
        timer.fire()
        RunLoop.main.add(timer, forMode: .common)
    }
    
    /// calling `.finish()` on a feed session instance will set its status to FeedSessionStatus.complete
    /// and write back to the store. .complete'd feed sessions can't be resumed
    func finish() throws {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        self.status = .complete
        self.timer.invalidate()
        
        do {
            try context.save()
        }catch {
        }
    }
    
    /// checks the current side the child is feeding from and appends a new Feed instance with the Feed.BreastSide alternated left<->right
    public func switchSide() {
        guard let context = self.managedObjectContext else {
            fatalError()
        }

        /// get either the current feed or the last known one then alternate the side value
        let feed: Feed? = currentFeed
        let side = feed?.breastSide == .left ? Feed.BreastSide.right : Feed.BreastSide.left
        
        let switchedFeed = Feed(side: side, insertIntoManagedObjectContext: context)

        /// add it to our array of feed instances
        self.addToFeeds(switchedFeed)

//        /// notify observers of changes
//        self.objectWillChange.send()
//        self.child?.objectWillChange.send()

        /// save changes
        do {
            try context.save()
            
            print(UserDefaults.standard.bool(forKey: "pauseTimerWhenSwitching"))
            if UserDefaults.standard.bool(forKey: "pauseTimerWhenSwitching") {
                self.pause()
            }else {
                self.resume()
            }
        }catch {
            fatalError()
        }
    }
    
    public var title: String {
        "Feed Session"
    }
    
    public var details: String {
        "bottle feed details"
    }
}
