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
    /// fetch all trackable entities (feeds, nappy changes etc)
    func allTrackableEntities() -> [Trackable] {
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
//    func trackableEntitiesBetween(start dateFrom: Date, end dateTo: Date) -> [Trackable] {
//        guard dateFrom < dateTo else {
//            return []
//        }
//
//        guard let context = self.managedObjectContext else {
//            return []
//        }
//
//        var calendar = Calendar.current
//        calendar.timeZone = NSTimeZone.local
//
//        let dateFromPredicate = NSPredicate(format: "createdAt >= %@", dateFrom as NSDate)
//        let dateToPredicate   = NSPredicate(format: "createdAt < %@",  dateTo   as NSDate)
//
//        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dateFromPredicate, dateToPredicate])
//
//        let feedSessionFetchRequest:NSFetchRequest<FeedSession> = FeedSession.fetchRequest()
//        feedSessionFetchRequest.predicate = datePredicate
//
//        let nappyChangeFetchRequest:NSFetchRequest<NappyChange> = NappyChange.fetchRequest()
//        nappyChangeFetchRequest.predicate = datePredicate
//
//        let napFetchRequest:NSFetchRequest<Nap> = Nap.fetchRequest()
//        napFetchRequest.predicate = datePredicate
//
//        do {
//            let feedSessions = try context.fetch(feedSessionFetchRequest)
//            let nappyChangeFetchRequest = try context.fetch(nappyChangeFetchRequest)
//            let napFetchRequest = try context.fetch(napFetchRequest)
//
//            let allEntities = [feedSessions]
//
//            return allEntities.flatMap {$0}
//        }catch {
//            return []
//        }
//    }
    
    /// get 'todays' overview of activity
    func completedFeedsWithinRange(dateDange: Range<Date>) -> [FeedSession] {
        return self.feedSessionsArray.filter {
            $0.status == .complete && dateDange.contains($0.wrappedCreatedAt)
        }
    }
    
    func nappyChangesWithinRange(dateDange: Range<Date>) -> [NappyChange] {
        return self.nappyChangesArray.filter {
            dateDange.contains($0.wrappedCreatedAt)
        }
    }
    
    func napsWithinRange(dateDange: Range<Date>) -> [Nap] {
        return self.napsArray.filter {
            dateDange.contains($0.wrappedCreatedAt)
        }
    }
}
