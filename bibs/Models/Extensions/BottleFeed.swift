//
//  BottleFeed.swift
//  bibs
//
//  Created by Paul Hendrick on 09/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

extension BottleFeed: Identifiable, Trackable {
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
    
    public enum BottleFeedType: Int, CaseIterable, Hashable {
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
    
    public var status: BottleFeedType {
        get {
            BottleFeedType.init(rawValue: Int(self.state)) ?? .expressedMilk
        }
        
        set(newValue) {
            state = Int16(newValue.rawValue)
        }
    }
    
    public var title: String {
        "Bottle Feed"
    }
    
    public var details: String {
        "bottle feed details"
    }
    
    public var trackableUnit: Int32 {
        Int32(self.amount)
    }
}
