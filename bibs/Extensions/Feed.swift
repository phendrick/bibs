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
    convenience init(status: Feed.FeedStatus, side: Feed.BreastSide, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entity(forEntityName: "Feed", in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.createdAt = Date()
        self.duration = 0
        self.status = status
    }
    
    enum FeedStatus: Int16 {
        case paused
        case running
    }
    
    enum BreastSide: Int16 {
        case left
        case right
    }
    
    var status: FeedStatus {
        get {
            FeedStatus.init(rawValue: self.state) ?? .paused
        }
        
        set(newValue) {
            state = newValue.rawValue
        }
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }

    var wrappedBreastSide: BreastSide {
        guard let side = BreastSide(rawValue: self.side) else {
            return .left
        }

        return side
    }

    var currentSide: BreastSide {
        guard let side = BreastSide(rawValue: self.side) else {
            return .left
        }

        return side
    }
    
    func setStatus(to status: FeedStatus) {
        state = status.rawValue
    }
    
    var calculatedElapsedTime: (hours: Int, minutes: Int, seconds: Int, hseconds: Int) {
        let hours    = Int((duration / 100) / 3600)
        let minutes  = Int((duration / 100) / 60 % 60)
        let seconds  = Int((duration / 100 ) % 60)
        let hseconds = Int((duration % 100))
        
        return (hours: hours, minutes: minutes, seconds: seconds, hseconds: hseconds)
    }
    
    var formattedElapsedTime: String {
        let hours    = String(calculatedElapsedTime.hours).toPaddedNumber()
        let minutes  = String(calculatedElapsedTime.minutes).toPaddedNumber()
        let seconds  = String(calculatedElapsedTime.seconds).toPaddedNumber()
        let hseconds = String(calculatedElapsedTime.hseconds).toPaddedNumber()
        
        return "\(hours):\(minutes):\(seconds).\(hseconds)"
    }
}
