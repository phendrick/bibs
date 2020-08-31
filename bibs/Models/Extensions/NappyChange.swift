//
//  FeedSession+Timers.swift
//  bibs
//
//  Created by Paul Hendrick on 26/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension NappyChange: Identifiable, Trackable {
    public enum NappyChangeType: Int, CaseIterable {
        case wet
        case dirty
        case both
        case dry
        
        var description: String {
            switch self {
                case .wet: return "Wet"
                case .dirty: return "Dirty"
                case .both: return "Wet & Dirty"
                case .dry: return "Dry"
            }
        }
    }
    
    public enum NappyChangeAmountType: Int, CaseIterable {
        case light
        case normal
        case heavy
        
        var description: String {
            switch self {
                case .light: return "Light"
                case .normal: return "Regular"
                case .heavy: return "Heavy"
            }
        }
    }
    
    public enum NappyChangePoopColor: Int, CaseIterable {
        case black
        case green
        case brown
        case yellow
        case white
        case red
        
        var color: UIColor {
            switch self {
            case .black:  return UIColor.black
            case .green:  return UIColor.systemGreen
            case .brown:  return UIColor.brown
            case .yellow: return UIColor.systemYellow
            case .white:  return UIColor(red: 0.949, green: 0.949, blue: 0.953, alpha: 1.000)
            case .red:    return UIColor.systemRed
            }
        }
        
        var details: (String, String, Int?) {
            switch self {
            case .black:  return (name: "Black", description: "Normal in newborns", daysWarning: 14)
            case .green:  return (name: "Green", description: "Can be caused medication or allergies", daysWarning: nil)
            case .brown:  return (name: "Brown", description: "Normal", daysWarning: nil)
            case .yellow: return (name: "Yellow", description: "Normal in breastfed babies", daysWarning: nil)
            case .white:  return (name: "White", description: "Seek medical advice", daysWarning: 0)
            case .red:    return (name: "Red", description: "Seek medical advice", daysWarning: 0)
            }
        }
    }
    
    public var status: NappyChangeType {
        get {
            NappyChangeType.init(rawValue: Int(self.state)) ?? .wet
        }
        
        set(newValue) {
            state = Int16(newValue.rawValue)
        }
    }
    
    public var detail: NappyChangeAmountType {
        get {
            NappyChangeAmountType.init(rawValue: Int(self.amount)) ?? .light
        }
        
        set(newValue) {
            amount = Int16(newValue.rawValue)
        }
    }
    
    public var poopColor: NappyChangePoopColor {
        get {
            NappyChangePoopColor.init(rawValue: Int(self.color)) ?? .brown
        }
        
        set(newValue) {
            color = Int16(newValue.rawValue)
        }
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
    
    public var title: String {
        "Nappy Change"
    }
    
    public var details: String {
        "nappy change description"
    }
    
    public var trackableUnit: Int32 {
        0
    }
}
