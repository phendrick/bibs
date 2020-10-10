//
//  Feed+Switchable.swift
//  bibs
//
//  Created by Paul Hendrick on 26/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import CoreData

extension Feed: Identifiable, Timeable {
    convenience init(side: Feed.BreastSide, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entity(forEntityName: "Feed", in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.breastSide = side
        self.createdAt = Date()
        self.duration = 0
    }
    
    enum BreastSide: Int16, CaseIterable {
        case left
        case right
        
        var description: (String, String, String) {
            switch(self) {
                case .left: return (full: "left_side".localized, label: "l_side".localized, short: "l_side".localized)
                case .right: return (full: "right_side".localized, label: "r_side".localized, short: "r_side".localized)
            }
        }
        
        var switched: BreastSide {
            switch(self) {
            case .left: return .right
            case .right: return .left
            }
        }
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }

    var breastSide: BreastSide {
        get {
            BreastSide.init(rawValue: self.side) ?? .left
        }
        
        set(newValue) {
            side = newValue.rawValue
        }
    }
    
    var calculatedElapsedTime: (hours: Int, minutes: Int, seconds: Int, hseconds: Int) {
        let hours    = Int((duration / 100) / 3600)
        let minutes  = Int((duration / 100) / 60 % 60)
        let seconds  = Int((duration / 100 ) % 60)
        let hseconds = Int((duration % 100))
        
        return (hours: hours, minutes: minutes, seconds: seconds, hseconds: hseconds)
    }
    
    /// formatted string to render the elapsed time
    func formattedElapsedTime(include_hsec: Bool = true) -> String {
        var time = String(format:"%02i:%02i:%02i", calculatedElapsedTime.hours, calculatedElapsedTime.minutes, calculatedElapsedTime.seconds)
        
        if include_hsec {
            time.append(contentsOf: String(format: ".%02i", calculatedElapsedTime.hseconds))
        }
        
        return time
    }
    
    func setDurationFromValues(hours: Int, minutes: Int, seconds: Int) -> (hours: Int, minutes: Int, seconds: Int, hseconds: Int)? {
        self.duration = Int32(hours*3600 + minutes*60 + seconds) * 100
        
        return calculatedElapsedTime
    }
}
