//
//  Snack+snackList.swift
//  bibs
//
//  Created by Paul Hendrick on 27/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

extension Snack {
    enum SnackType: Int16, CaseIterable {
        case vegetables
        case fruit
        case roots
        case protein
        case dairy
        
        var description: String {
            switch(self) {
            case .vegetables: return "Vegetables"
            case .fruit: return "Fruit"
            case .roots: return "Starchy foods"
            case .protein: return "Proteins"
            case .dairy: return "Dairy"
            }
        }
        var details: String {
            switch(self) {
            case .vegetables: return "Carrots, broccoli, peas, avocado, cauliflower"
            case .fruit: return "Kiki, strawberries, melon, mango, apples"
            case .roots: return "Pasta, potatoes, quinoa, bread, oats, chapatti"
            case .protein: return "Beans, lentils, chicken, beef, lamb, chickpeas"
            case .dairy: return "Eggs, yoghurt, milk"
            }
        }
    }
    
    var snackType: SnackType {
        get {
            SnackType.init(rawValue: self.state) ?? .vegetables
        }
        
        set(newValue) {
            state = newValue.rawValue
        }
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
}
