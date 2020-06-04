//
//  ActiveFeeds.swift
//  bibs
//
//  Created by Paul Hendrick on 24/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import Combine

final class ActiveFeedSessions: ObservableObject {
    @Published var feedSessions: [FeedSession] = []
    
    static let shared = ActiveFeedSessions()
    
    private init() {}
    
    func addToActiveFeedSessions(feedSession : FeedSession) {
        feedSessions.append(feedSession)
    }
    
    subscript(i: Int) -> FeedSession? {
        return feedSessions.count > i ? feedSessions[i] : nil
    }
    
    deinit {
        print("deinit ActiveFeedSessions")
    }
}
