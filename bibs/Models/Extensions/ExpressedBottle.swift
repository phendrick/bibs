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
        case donated
        case disposed
        
        var description: String {
            switch(self) {
                case .fresh: return "Fresh"
                case .refridgerated: return "Refridgerated"
                case .frozen: return "Frozen"
                case .disposed: return "Disposed"
                case .donated: return "Donated"
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
    
    static var permittedUsableStates: [ExpressedBottleStorageStatus] {
        [.fresh, .refridgerated, .frozen]
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
}
