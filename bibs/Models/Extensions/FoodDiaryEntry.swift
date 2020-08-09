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
            case .vegetables: return "Vegetables"
            case .fruit: return "Fruit"
            case .roots: return "Starchy foods"
            case .protein: return "Proteins"
            case .dairy: return "Dairy"
            case .sweets: return "Sweets"
            }
        }
        var details: String {
            switch(self) {
            case .vegetables: return "Carrots, broccoli, peas, avocado, cauliflower"
            case .fruit: return "Kiki, strawberries, melon, mango, apples"
            case .roots: return "Pasta, potatoes, quinoa, bread, oats, chapatti"
            case .protein: return "Beans, lentils, chicken, beef, lamb, chickpeas"
            case .dairy: return "Eggs, yoghurt, milk"
            case .sweets: return "Dried fruits, fruit rolls, chocolate"
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
