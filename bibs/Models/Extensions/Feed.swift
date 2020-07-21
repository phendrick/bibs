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
                case .left: return (full: "Left side", label: "L", short: "Left")
                case .right: return (full: "Right side", label: "R", short: "Right")
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
    
    func setDurationFromStrings(hours: String, minutes: String, seconds: String) -> (hours: Int, minutes: Int, seconds: Int, hseconds: Int)? {
        guard let h = Int(hours), let m = Int(minutes), let s = Int(seconds) else {
            return nil
        }
        
        self.duration = Int32(h*3600 + m*60 + s) * 100
        
        return calculatedElapsedTime
    }
}
