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
        case active
        case paused
        case complete
    }
    
    enum FeedSessionError: Error {
        case noActiveFeed
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
    
    //Toggle's the current feeding side, marks the current feed's state as complete and appends a new .active feed to the feed session
    var isActive: Bool {
        return self.state == FeedSession.FeedSessionStatus.active.rawValue
    }
    
    var status: FeedSessionStatus {
        get {
            if let sessionStatus = FeedSessionStatus(rawValue: self.state) {
                return sessionStatus
            }
            
            return .inactive
        }
        
        set(newValue) {
            self.state = newValue.rawValue
        }
    }
    
    func setStatus(to status: FeedSessionStatus) {
        self.status = status
        try? self.managedObjectContext?.save()
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
    
    // MARK: public api for controlling sessions
    func pause() throws {
        defer {
            self.setStatus(to: .inactive)
        }
        
        guard let feed = activeFeed else {
            throw FeedSessionError.noActiveFeed
        }
        
        feed.setStatus(to: .inactive)
    }
    
    func resume() throws {
        guard let moc = self.managedObjectContext else {
            fatalError()
        }
        
        if let feed = activeFeed {
            feed.setStatus(to: .active)
        }else {
            let feed = buildFeed(moc: moc, status: .active)
            self.addToFeeds(feed)
            self.activeFeed = feed

            try? moc.save()
        }
        
        self.setStatus(to: .active)
    }
    
    func finish() throws {
        defer {
            self.setStatus(to: .complete)
        }
        
        guard let feed = activeFeed else {
            throw FeedSessionError.noActiveFeed
        }
        
        feed.setStatus(to: .complete)
    }
    
    func toggle() throws {
        print(".toggle() \(status)")
        
        if status == .active {
            try pause()
        }else {
            try resume()
        }
    }
    
    public func switchSide() {
        guard let context = self.managedObjectContext else {
            fatalError()
        }

        // get either the current feed or the last known one then alternate the side value
        let currentFeed: Feed? = activeFeed ?? feedsArray.last
        let side = currentFeed?.currentSide == Feed.BreastSide.left ? Feed.BreastSide.right.rawValue : Feed.BreastSide.left.rawValue
        
        // if we have a current feed, set it to .complete and build a new .active feed
        if let feed = currentFeed {
            feed.setStatus(to: .complete)
        }

        let switchedFeed = buildFeed(moc: context, status: .active)
        switchedFeed.createdAt = Date()
        switchedFeed.state = Feed.FeedStatus.inactive.rawValue
        switchedFeed.side = side
        
        // set the new feed as the active one, and add it to our array of feeds
        activeFeed = switchedFeed
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
        feed.setStatus(to: status)
        
        return feed
    }
}
