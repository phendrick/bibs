//
//  FeedSession+Timers.swift
//  bibs
//
//  Created by Paul Hendrick on 26/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import CoreData

extension FeedSession: Identifiable, Timeable {
    convenience init(withFeed feed: Feed) {
        self.init()
        
        self.addToFeeds(feed)
        
        if let moc = self.managedObjectContext {
            try? moc.save()
        }
    }
    
    enum FeedSessionStatus: Int16 {
        case inactive
        case running
        case paused
        case complete
    }
    
    enum FeedSessionError: Error {
        case noCurrentFeed
    }
    
    var currentFeed: Feed? {
        feedsArray.last
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
    
    public var feedsArray: [Feed] {
        let set = feeds as? Set<Feed> ?? []
        return set.sorted {$0.wrappedCreatedAt < $1.wrappedCreatedAt}
    }
    
    var duration: Int32 {
        return feedsArray.reduce(into: 0) { (total, feed) in
            total += feed.duration
        }
    }
    
    var calculatedElapsedTime: (hours: Int, minutes: Int, seconds: Int, hseconds: Int) {
        let hours    = Int((duration / 100) / 3600)
        let minutes  = Int((duration / 100) / 60 % 60)
        let seconds  = Int((duration / 100 ) % 60)
        let hseconds = Int((duration % 100))
        
        return (hours: hours, minutes: minutes, seconds: seconds, hseconds: hseconds)
    }
    
    var formattedElapsedTime: String {
        let hours    = String(calculatedElapsedTime.hours).toPaddedNumber()
        let minutes  = String(calculatedElapsedTime.minutes).toPaddedNumber()
        let seconds  = String(calculatedElapsedTime.seconds).toPaddedNumber()
        let hseconds = String(calculatedElapsedTime.hseconds).toPaddedNumber()
        
        return "\(hours):\(minutes):\(seconds).\(hseconds)"
    }
    
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            guard let feed = self.currentFeed else {
                print("nah")
                return
            }
            
            if self.currentTimerMode == .paused {
                timer.invalidate()
                print(".paused. nah")
                return
            }
            
            print("Adding 0.01: \(self.currentTimerMode)")
            feed.duration += 1
            self.child?.objectWillChange.send()
        }
    }
    
    // MARK: public api for controlling sessions
    func pause() throws {
        self.currentTimerMode = .paused
    }
    
    func resume() {
        guard currentTimerMode != .running else {
            return
        }
        
        self.currentTimerMode = .running
        timer.fire()
    }
    
    func finish() throws {
        print("feed.setStatus(to: .complete")
    }
    
    func start() {
        guard currentTimerMode != .running else {
            return
        }
        print("Start()")
        
        currentTimerMode = .running
        timer.fire()
    }
    
    func toggle() {
        guard let feed = currentFeed else {
            return
        }
        
        print("toggle() checking feed.status (\(feed.status))")
        if feed.status == .active {
            try? pause()
        }else {
            resume()
        }
    }
    
    public func switchSide() {
        guard let context = self.managedObjectContext else {
            fatalError()
        }

        // get either the current feed or the last known one then alternate the side value
        let feed: Feed? = currentFeed
        let side = feed?.currentSide == Feed.BreastSide.left ? Feed.BreastSide.right.rawValue : Feed.BreastSide.left.rawValue
        
        let switchedFeed = buildFeed(moc: context, status: .active)
        switchedFeed.createdAt = Date()
        switchedFeed.side = side
        
        // set the new feed as the active one, and add it to our array of feeds
        self.addToFeeds(switchedFeed)
        
        // notify ancestors of changes
        self.objectWillChange.send()
        self.child?.objectWillChange.send()

        // save changes
        try? context.save()
    }
    
    private func buildFeed(moc: NSManagedObjectContext, status: Feed.FeedStatus) -> Feed {
        let feed = Feed(context: moc)
        feed.createdAt = Date()
        feed.duration = 0
        
        return feed
    }
}
