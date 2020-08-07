//
//  ActiveFeeds.swift
//  bibs
//
//  Created by Paul Hendrick on 24/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import Combine

final class ProfileObserver: ObservableObject {
    @Published var parent: ParentProfile!
    @Published var trayHeight: CGFloat = 0
    
    static let shared = ProfileObserver()
    
    private init() {}
    
    func setOffsetForLayout(layout: ActiveFeedsTrayView.ExpandedState) {
        var height: CGFloat = 0
        let currentSessions = self.parent.currentFeedSessions.count
        let inactiveSessions = self.parent.childrenWithoutCurrentFeedSessions.count
        let currentSessionsMultiplier = layout == .minimised ? 1 : currentSessions
        
        if inactiveSessions > 0 {
            height += 150
        }
        
        let timerHeight = layout == .expanded ? 180 : 150
        
        height += CGFloat((timerHeight * currentSessionsMultiplier))
        
        self.trayHeight = CGFloat(height)
    }
}
