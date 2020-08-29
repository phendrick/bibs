//
//  ExpressedBottle.swift
//  bibs
//
//  Created by Paul Hendrick on 09/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

extension ExpressedBottle: Identifiable, Trackable {
    public enum ExpressedBottleStorageStatus: Int16, CaseIterable {
        case refridgerated
        case fresh
        case frozen
        case thawed
        case donated
        case disposed
        
        var description: String {
            switch(self) {
                case .refridgerated: return "Refridgerated"
                case .fresh: return "Room temperature"
                case .frozen: return "Frozen"
                case .thawed: return "Thawed"
                case .disposed: return "Disposed of"
                case .donated: return "Donated"
            }
        }
        
        var details: String {
            switch(self) {
                case .refridgerated: return "Refridgerated milk will last for"
                case .fresh: return "Make sure to dispose if..."
                case .frozen: return "You can keep milk in the freezer for"
                case .thawed: return "You can keep thawed milk for"
                case .disposed: return "Safely dispose of. Or consider donating"
                case .donated: return "❤️"
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
        "Expressed Bottle"
    }
    
    public var details: String {
        "bottle feed details"
    }
    
    public var trackableUnit: Int {
        Int(self.amount)
    }
}
