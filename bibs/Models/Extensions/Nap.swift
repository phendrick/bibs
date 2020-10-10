//
//  Feed+Switchable.swift
//  bibs
//
//  Created by Paul Hendrick on 26/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import CoreData

public enum NapStatus: CaseIterable {
    case napping
    case done
}

extension Nap: Identifiable, Timeable, Trackable {
    public var status: NapStatus {
        get {
            return .done
        }
        
        set {
        }
    }
    
    public var title: String {
        return self.child?.wrappedName ?? ""
    }
    
    public var details: String {
        return ""
    }
    
    public var trackableUnit: Int32 {
        return duration
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
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
    
    public static func trackableItemsWithinRange(range: Range<Date>, context: NSManagedObjectContext?) -> [Nap] {
        let dateFromPredicate = NSPredicate(format: "createdAt >= %@", range.lowerBound as NSDate)
        let dateToPredicate   = NSPredicate(format: "createdAt =< %@",  range.upperBound as NSDate)

        let datePredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [dateFromPredicate, dateToPredicate]
        )
        
        let request:NSFetchRequest<Nap> = Nap.fetchRequest()
        request.predicate = datePredicate
        
        do {
            return try context?.fetch(request) ?? []
        }catch {
            return []
        }
    }
}
