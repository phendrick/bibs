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
    enum NappyChangeType: Int, CaseIterable {
        case wet
        case dirty
        case both
        
        var description: String {
            switch self {
                case .wet: return "Wet"
                case .dirty: return "Dirty"
                case .both: return "Wet & Dirty"
            }
        }
    }
    
    var status: NappyChangeType {
        get {
            NappyChangeType.init(rawValue: Int(self.state)) ?? .wet
        }
        
        set(newValue) {
            state = Int16(newValue.rawValue)
        }
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
}
