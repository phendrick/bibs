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
    public enum NappyChangeType: Int, CaseIterable, Hashable, TrackableStatus {
        case wet
        case dirty
        case both
        case dry
        
        public var description: String {
            switch self {
                case .wet: return "wet".localized
                case .dirty: return "dirty".localized
                case .both: return "wet_and_dirty".localized
                case .dry: return "dry".localized
            }
        }
        
        public var emoji: String {
            return ""
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(self.rawValue)
        }
    }
    
    public enum NappyChangeAmountType: Int, CaseIterable {
        case light
        case normal
        case heavy
        
        var description: String {
            switch self {
                case .light: return "light".localized
                case .normal: return "regular".localized
                case .heavy: return "heavy".localized
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
            case .black:  return (name: "black".localized,  description: "black_details".localized,  daysWarning: 14)
            case .green:  return (name: "green".localized,  description: "green_details".localized,  daysWarning: nil)
            case .brown:  return (name: "brown".localized,  description: "brown_details".localized,  daysWarning: nil)
            case .yellow: return (name: "yellow".localized, description: "yellow_details".localized, daysWarning: nil)
            case .white:  return (name: "white".localized,  description: "white_details".localized,  daysWarning: 0)
            case .red:    return (name: "red".localized,    description: "red_details".localized,    daysWarning: 0)
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
    
    public static func trackableItemsWithinRange(range: Range<Date>, context: NSManagedObjectContext?) -> [NappyChange] {
        let dateFromPredicate = NSPredicate(format: "createdAt >= %@", range.lowerBound as NSDate)
        let dateToPredicate   = NSPredicate(format: "createdAt =< %@",  range.upperBound as NSDate)

        let datePredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [dateFromPredicate, dateToPredicate]
        )
        
        let request:NSFetchRequest<NappyChange> = NappyChange.fetchRequest()
        request.predicate = datePredicate
        
        do {
            return try context?.fetch(request) ?? []
        }catch {
            return []
        }
    }
}
