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
    private init() {}
    
    @Published var parent: ParentProfile!
    
    static let shared = ProfileObserver()
    
    var activeFeedSessions: [FeedSession] = []
    
    
    func addToActiveFeedSessions(session: FeedSession) {
        guard self.activeFeedSessions.firstIndex(of: session) == nil else {
            return
        }
        
        activeFeedSessions.append(session)
    }
    
    func removeFromActiveFeedSessions(session: FeedSession) {
        guard let index = self.activeFeedSessions.firstIndex(of: session) else {
            return
        }
        
        activeFeedSessions.remove(at: index)
    }
    
    var trayHeight: CGFloat {
        guard self.parent.breastfeedingChildrenArray.count > 0  else {
            return 0
        }
        
        var baseHeight: CGFloat = 140
        
        if #available(iOS 14.0, *) {
            baseHeight = 125
        }else if #available(iOS 13.0, *), UIDevice.current.hasLargeScreen {
            baseHeight = 85
        }else {
            baseHeight = 95
        }
        
        if UIDevice.current.hasLargeScreen {
            baseHeight += 15
        }else if (667...810).contains(UIScreen.main.bounds.size.height) {
            baseHeight += 25
        }else {
            baseHeight += 15
        }
        
        return baseHeight
    }
}
