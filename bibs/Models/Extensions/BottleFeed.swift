//
//  BottleFeed.swift
//  bibs
//
//  Created by Paul Hendrick on 09/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

extension BottleFeed: Identifiable {
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
    
    enum BottleFeedType: Int, CaseIterable {
        case expressedMilk
        case donorMilk
        case formula
        
        var description: String {
            switch(self) {
                case .expressedMilk: return "Expressed Milk"
                case .donorMilk: return "Donor milk"
                case .formula: return "Formula"
            }
        }
    }
    
    var status: BottleFeedType {
        get {
            BottleFeedType.init(rawValue: Int(self.state)) ?? .expressedMilk
        }
        
        set(newValue) {
            state = Int16(newValue.rawValue)
        }
    }
}
