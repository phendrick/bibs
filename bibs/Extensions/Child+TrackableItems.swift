//
//  Child+Trackable.swift
//  bibs
//
//  Created by Paul Hendrick on 15/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import CoreData

extension Child {
    func allTrackableEntities() -> [NSManagedObject] {
        guard let context = self.managedObjectContext else {
            return []
        }

        let feedSessionFetchRequest:NSFetchRequest<FeedSession> = FeedSession.fetchRequest()

        do {
            let feedSessions = try context.fetch(feedSessionFetchRequest)

            return feedSessions
        }catch {
            return []
        }
    }
    
    /// fetch all entities within two given dates
    func trackableEntitiesBetween(start dateFrom: Date, end dateTo: Date) -> [Trackable] {
        guard dateFrom < dateTo else {
            return []
        }
        
        guard let context = self.managedObjectContext else {
            return []
        }
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFromPredicate = NSPredicate(format: "createdAt >= %@", dateFrom as NSDate)
        let dateToPredicate   = NSPredicate(format: "createdAt < %@",  dateTo   as NSDate)
        
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dateFromPredicate, dateToPredicate])
        
        let feedSessionFetchRequest:NSFetchRequest<FeedSession> = FeedSession.fetchRequest()
        feedSessionFetchRequest.predicate = datePredicate
        
        do {
            let feedSessions = try context.fetch(feedSessionFetchRequest)
            let allEntities = [feedSessions]
            
            return allEntities.flatMap {$0}
//                .sorted { (lhs, rhs) -> Bool in
//                lhs.createdAt < rhs.createdAt
//            }
        }catch {
            return []
        }
    }
    
    /// get 'todays' overview of activity
    func todaysTrackableEntities() -> [Trackable] {
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo   = calendar.date(byAdding: .day, value: 1, to: dateFrom) ?? dateFrom
        
        return trackableEntitiesBetween(start: dateFrom, end: dateTo)
    }
}
