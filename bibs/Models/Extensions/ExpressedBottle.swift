//
//  ExpressedBottle.swift
//  bibs
//
//  Created by Paul Hendrick on 09/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

extension ExpressedBottle: Identifiable {
    enum ExpressedBottleStorageStatus: Int16, CaseIterable {
        case fresh
        case refridgerated
        case frozen
        case inUse
        case partiallyUsed
        case disposed
        
        var description: String {
            switch(self) {
                case .fresh: return "Fresh"
                case .refridgerated: return "Refridgerated"
                case .frozen: return "Frozen"
                case .inUse: return "In use"
                case .partiallyUsed: return "Partially used"
                case .disposed: return "Disposed"
            }
        }
    }
    
    var status: ExpressedBottleStorageStatus {
        get {
            ExpressedBottleStorageStatus.init(rawValue: self.state) ?? .refridgerated
        }
        
        set(newValue) {
            state = newValue.rawValue
        }
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
    
    public func save() {
        do {
            try self.managedObjectContext?.save()
        }catch {
        }
    }
}
