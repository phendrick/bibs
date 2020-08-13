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
        guard layout != .expanded else {
            return
        }
        
        let padding: CGFloat = 70
        
        var height: CGFloat = (UIScreen.main.bounds.size.height / 12)
        
        switch(layout) {
        case .expanded: height *= 2
        case .minimised: height *= 1.4
        }
        
        self.trayHeight = CGFloat(height + padding)
    }
}
