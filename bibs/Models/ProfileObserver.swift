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
    
    static let shared = ProfileObserver()
    
    private init() {}
    
    var trayHeight: CGFloat {
        let baseHeight: CGFloat = 140
        
        return self.parent.currentFeedSessions.count > 0 ? baseHeight + 30 : baseHeight
    }
    
    var multipleWaiting: Bool {
        (self.parent.currentFeedSessions.count > 0 && self.parent.childrenWithoutCurrentFeedSessions.count > 1)
    }
}
