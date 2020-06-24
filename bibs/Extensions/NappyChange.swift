//
//  FeedSession+Timers.swift
//  bibs
//
//  Created by Paul Hendrick on 26/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import CoreData

extension NappyChange: Identifiable {
    enum NappyChangeType: Int16 {
        case wet
        case dirty
        case both
    }
    
    var status: NappyChangeType {
        get {
            NappyChangeType.init(rawValue: self.state) ?? .wet
        }
        
        set(newValue) {
            state = newValue.rawValue
            self.child?.objectWillChange.send()
        }
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
}
