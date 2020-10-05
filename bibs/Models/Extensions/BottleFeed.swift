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
                case .expressedMilk: return "expressed_milk".localized
                case .donorMilk: return "donor_milk".localized
                case .formula: return "formula_milk".localized
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
        "bottle_feed"
    }
    
    public var details: String {
        "bottle_feed_details"
    }
    
    public var trackableUnit: Int32 {
        Int32(self.amount)
    }
}
