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
            case .vegetables: return "vegetables".localized
            case .fruit: return "fruit".localized
            case .roots: return "starchy_foods".localized
            case .protein: return "proteins".localized
            case .dairy: return "dairy".localized
            }
        }
        
        var details: String {
            switch(self) {
            case .vegetables: return "weaning_vegetables".localized
            case .fruit: return "weaning_fruit".localized
            case .roots: return "weaning_starchy_foods".localized
            case .protein: return "weaning_proteins".localized
            case .dairy: return "weaning_dairy".localized
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
