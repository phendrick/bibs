//
//  ActiveFeeds.swift
//  bibs
//
//  Created by Paul Hendrick on 24/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import Combine

final class ActiveChildProfile: ObservableObject {
    @Published var child: Child!
    
    static let shared = ActiveChildProfile()
    
    private init() {}
    
    func setActiveChildProfile(child: Child) {
        self.child = child
    }
    
    deinit {
        print("deinit ActiveChildren")
    }
}
