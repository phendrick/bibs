//
//  FoodDiaryEntry.swift
//  bibs
//
//  Created by Paul Hendrick on 29/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

extension FoodDiaryEntry {
    enum FoodType: Int16, CaseIterable {
        case vegetables
        case fruit
        case roots
        case protein
        case dairy
        case sweets
        
        var description: String {
            switch(self) {
            case .vegetables: return "vegetables".localized
            case .fruit: return "fruit".localized
            case .roots: return "starchy_foods".localized
            case .protein: return "proteins".localized
            case .dairy: return "dairy".localized
            case .sweets: return "sweets".localized
            }
        }
        var details: String {
            switch(self) {
            case .vegetables: return "weaning_vegetables"
            case .fruit: return "weaning_fruit"
            case .roots: return "weaning_starchy_foods"
            case .protein: return "weaning_proteins"
            case .dairy: return "weaning_dairy"
            case .sweets: return "weaning_sweets"
            }
        }
        var emoji: String {
            switch(self) {
            case .vegetables: return "🌽"
            case .fruit: return "🍏"
            case .roots: return "🥔"
            case .protein: return "🍗"
            case .dairy: return "🥛"
            case .sweets: return "🍭"
            }
        }
    }
    
    var foodType: FoodType {
        get {
            FoodType.init(rawValue: self.state) ?? .vegetables
        }
        
        set(newValue) {
            state = newValue.rawValue
        }
    }
    
    public var wrappedCreatedAt: Date {
        get {createdAt ?? Date()}
        set {createdAt = newValue}
    }
}
