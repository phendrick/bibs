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
    enum FeedSessionStatus: Int16 {
        case paused
        case running
        case complete
    }
    
    enum FeedSessionError: Error {
        case noCurrentFeed
    }
    
    var status: FeedSessionStatus {
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
        let hours    = String(calculatedElapsedTime.hours).toPaddedNumber()
        let minutes  = String(calculatedElapsedTime.minutes).toPaddedNumber()
        let seconds  = String(calculatedElapsedTime.seconds).toPaddedNumber()
        let hseconds = String(calculatedElapsedTime.hseconds).toPaddedNumber()
        
        var time = "\(hours):\(minutes):\(seconds)"
        
        if include_hsec {
            time.append(".\(hseconds)")
        }
        
        return time
    }
    
    /// a basic timer implementation.
    /// the timer stops incrementing and invalidate's itself when the current timer `.status` is set to `.paused`, so
    /// we can call `feedSession.pause()` or  `feedSession.setStatus(to: .paused)` to stop a timer
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            guard let feed = self.currentFeed else {
                print("no current feed")
                return
            }
            
            print("feed.duration: \(feed.duration), \(self.status)")
            
            if self.status != .running {
                timer.invalidate()
                
                return
            }
            
            feed.duration += 1
            self.objectWillChange.send()
        }
    }
    
    /// MARK: public api for controlling sessions
    func pause() {
        self.status = .paused
    }
    
    func resume() {
        /// guard against calling .fire() on an already .running timer since we'll be incrememnting the duration for each fired timer
        guard status != .running else {
            return
        }
        
        self.status = .running
        timer.fire()
    }
    
    /// calling `.finish()` on a feed session instance will set its status to FeedSessionStatus.complete
    /// and write back to the store. .complete'd feed sessions can't be resumed
    func finish() throws {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        self.status = .complete
        
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

        /// notify observers of changes
        self.objectWillChange.send()
        self.child?.objectWillChange.send()

        /// save changes
        try? context.save()
    }
}
