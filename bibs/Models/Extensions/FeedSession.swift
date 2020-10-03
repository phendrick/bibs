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
    public enum FeedSessionStatus: Int16, CaseIterable, Hashable {
        case paused    // manually paused by user
        case running   // incrementing feed duration value
        case complete  // is an old feed session
        case suspended // suspended when user backgrounds the app
        
        var description: String {
            switch(self) {
            case .paused: return "Paused"
            case .running: return "Running"
            case .complete: return "Complete"
            case .suspended: return "Suspended"
            }
        }
    }
    
    public var status: FeedSessionStatus {
        get {
            FeedSessionStatus.init(rawValue: self.state) ?? .paused
        }
        
        set(newValue) {
            state = newValue.rawValue
        }
    }
    
    enum FeedSessionError: Error {
        case noCurrentFeed
    }
    
    var isActiveFeedSession: Bool {
        status == .running || status == .paused
    }
    
    var currentFeed: Feed? {
        return feedsArray.last
    }
    
    var currentBreastSide: Feed.BreastSide {
        return currentFeed?.breastSide ?? .left
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
    var duration: Duration {
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
    
    func formattedElapsedTimeHsecs(includeRandomMsec: Bool = false) -> String {
        var hsecs = calculatedElapsedTime.hseconds
        
        if includeRandomMsec && hsecs != 0 {
            hsecs = max(calculatedElapsedTime.hseconds + (1...8).randomElement()!, 9)
        }
        
        return String(format: ".%02i", hsecs)
    }
    
    /// a basic timer implementation.
    /// the timer stops incrementing and invalidate's itself when the current timer `.status` is set to `.paused`, so
    /// we can call `feedSession.pause()` or  `feedSession.setStatus(to: .paused)` to stop a timer
    var timer: Timer {
        Timer(timeInterval: 0.1, repeats: true) { (timer) in
            guard let feed = self.currentFeed else {
                timer.invalidate()
                return
            }
            
            if self.status != .running {
                timer.invalidate()
            }
            
            feed.duration += 10
            
            self.child?.objectWillChange.send()
        }
    }
    
    /// MARK: public api for controlling sessions
    func pause() {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        guard status == .running || status == .suspended else {
            return
        }
        
        self.status = .paused
        self.timer.invalidate()
        
        do {
            try context.save()
        }catch {
        }
    }
    
    /// save a session to be resumed later
    /// if `hibernate` is set to true, we dont invalidate the timer as we may still only be in preview mode, not fully switched to the background
    func suspend() {
        guard status == .running else {
            return
        }
        
        self.suspendedAt = Date()
        self.status = .suspended
        timer.invalidate()
    }
    
    func unsuspend() {
        self.suspendedAt = nil
        
        if self.status != .paused {
            self.resume()
        }
    }
    
    func resume() {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        /// guard against calling .fire() on an already .running timer since we'll be incrememnting the duration for each fired timer
        /// unless the timer is being resumed from suspension, inwhich case its timer will be invalid and needs to be re-fired
        guard status != .running else {
            return
        }
        
        self.status = .running
        timer.fire()
        
        self.objectWillChange.send()
        
        RunLoop.main.add(timer, forMode: .common)
        
//        self.child?.parent?.profileObserver?.objectWillChange.send()
        
        self.child?.parent?.activeFeedSessions.forEach {
            $0.child?.objectWillChange.send()
        }
        
        do {
            try context.save()
        }catch {
        }
    }
    
    func complete() {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        self.status = .complete
        self.child?.activeFeedSession = nil
        
        self.child?.objectWillChange.send()
        
        do {
            try context.save()
        }catch {
        }
    }
    
    func toggle() {
        guard status == .paused || status == .running else {
            return
        }
        
        if status == .running {
            pause()
        }else {
            resume()
        }
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

        /// save changes
        do {
            try context.save()
            
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
    
    public var trackableUnit: Int32 {
        Int32(self.duration)
    }
    
//    public static func trackableItemsWithinRange(range: ClosedRange<Date>, context: NSManagedObjectContext) -> [FeedSession] {
//        
//        var calendar = Calendar.current
//        calendar.timeZone = NSTimeZone.local
//        
//        let dateFromPredicate = NSPredicate(format: "createdAt >= %@", range.lowerBound as NSDate)
//        let dateToPredicate   = NSPredicate(format: "createdAt < %@",  range.upperBound as NSDate)
//
//        let datePredicate = NSCompoundPredicate(
//            andPredicateWithSubpredicates: [dateFromPredicate, dateToPredicate]
//        )
//        
//        var request:NSFetchRequest<FeedSession> = FeedSession.fetchRequest()
//        request.predicate = datePredicate
//        
//        return try context.fetch(request) ?? []
//    }
}
