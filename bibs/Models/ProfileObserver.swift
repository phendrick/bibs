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
    
    var multipleWaiting: Bool {
        (self.parent.currentFeedSessions.count > 0 && self.parent.childrenWithoutCurrentFeedSessions.count > 1)
    }
    
    func setOffsetForLayout(layout: ActiveFeedsTrayView.ExpandedState) {
        var height: CGFloat = 180
        
        guard layout == .expanded else {
            self.trayHeight = height
            return 
        }
        
        let feedSessionHeight: CGFloat = 140
        let spacingHeight: CGFloat = 10
        
        height += (feedSessionHeight + spacingHeight) * CGFloat(self.parent.currentFeedSessions.count)
        
        print("HEIGHT: \(height)")
        // if we're feeding two children we dont show the tools so adjust the height down
        if self.parent.currentFeedSessions.count == 2 {
            height -= 140
        }
        
        self.trayHeight = height
    }
}
