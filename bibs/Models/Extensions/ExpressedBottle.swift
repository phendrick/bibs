//
//  ExpressedBottle.swift
//  bibs
//
//  Created by Paul Hendrick on 09/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

extension ExpressedBottle: Identifiable, Trackable {
    public enum ExpressedBottleStorageStatus: Int16, CaseIterable, Hashable {
        case refridgerated
        case fresh
        case frozen
        case thawed
        case donated
        case disposed
        
        var description: String {
            switch(self) {
                case .refridgerated: return "refridgerated".localized
                case .fresh: return "room_temperature".localized
                case .frozen: return "frozen".localized
                case .thawed: return "thawed".localized
                case .disposed: return "disposed".localized
                case .donated: return "donated".localized
            }
        }
        
        var details: String {
            switch(self) {
                case .refridgerated: return "refridgerated_details".localized
                case .fresh: return "room_temperature_details".localized
                case .frozen: return "frozen_details".localized
                case .thawed: return "thawed_details".localized
                case .disposed: return "disposed_details".localized
                case .donated: return "❤️".localized
            }
        }
        
        var emoji: String {
            switch(self) {
                case .refridgerated: return ""
                case .fresh: return ""
                case .frozen: return "❄️"
                case .thawed: return "🍼"
                case .disposed: return ""
                case .donated: return "❤️"
            }
        }
    }
    
    public var status: ExpressedBottleStorageStatus {
        get {
            ExpressedBottleStorageStatus.init(rawValue: self.state) ?? .refridgerated
        }
        
        set(newValue) {
            state = newValue.rawValue
        }
    }
    
    static var permittedUsableStates: [ExpressedBottleStorageStatus] {
        [.fresh, .refridgerated, .frozen, .thawed]
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
    
    public var convertedAmount: String {
        return "\(amount)ml"
    }
    
    public func save() {
        do {
            try self.managedObjectContext?.save()
        }catch {
        }
    }
    
    public var title: String {
        "expressed_bottle".localized
    }
    
    public var details: String {
        "bottle_feed_details".localized
    }
    
    public var trackableUnit: Int32 {
        Int32(self.amount)
    }
}
