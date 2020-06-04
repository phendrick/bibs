//
//  FeedSession+Timers.swift
//  bibs
//
//  Created by Paul Hendrick on 26/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import CoreData

extension FeedSession: Identifiable, TimeableFeedSession {
    
    enum FeedSessionStatus: Int16 {
        case notstarted
        case active
        case finished
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
    
    public var feedsArray: [Feed] {
        let set = feeds as? Set<Feed> ?? []
        return set.sorted {$0.wrappedCreatedAt < $1.wrappedCreatedAt}
    }
    
    var duration: Int {
        return feedsArray.reduce(into: 0) { (total, feed) in
            total += Int(feed.duration)
        }
    }
    
    public func switchSide() {
        var side:Int16 = 0
        
        guard let currentFeed = activeFeed else {
            return
        }

        side = currentFeed.side == 0 ? 1 : 0
        currentFeed.stopTimer()
        
        if let currentFeed = activeFeed {
            side = currentFeed.side == 0 ? 1 : 0
            currentFeed.stopTimer()
        }

        let feed = Feed()
        feed.side = side
        self.addToFeeds(feed)

        activeFeed = feed
        
        try? self.managedObjectContext?.save()
    }
}
