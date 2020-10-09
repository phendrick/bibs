//
//  ParentInsightGenerator.swift
//  bibs
//
//  Created by Paul Hendrick on 05/10/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import CoreData

typealias InsightReport = [String: [String]]
struct EmotionInsightsGenerator {
    var emotion: Emotion
    var context: NSManagedObjectContext
    var insightsDateRange: ClosedRange<Date> = (Date().advanced(by: -(3600*24*3))...Date())
    
    func generate() -> [String: [String]]? {
        let dateFromPredicate = NSPredicate(format: "createdAt >= %@", self.insightsDateRange.lowerBound as NSDate)
        let dateToPredicate   = NSPredicate(format: "createdAt < %@",  emotion.wrappedCreatedAt as NSDate)
        
        let predicates = [dateFromPredicate, dateToPredicate]
        
        let datePredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: predicates
        )
        
        let napsFetchRequest: NSFetchRequest<Nap> = Nap.fetchRequest()
        let feedsFetchRequest: NSFetchRequest<FeedSession> = FeedSession.fetchRequest()
        let bottlesFetchRequest: NSFetchRequest<BottleFeed> = BottleFeed.fetchRequest()
        
        napsFetchRequest.predicate = datePredicate
        feedsFetchRequest.predicate = datePredicate
        bottlesFetchRequest.predicate = datePredicate
        
        var results: [String: [String]] = [:]
        
        let naps    = try? self.context.fetch(napsFetchRequest)
        let feeds   = try? self.context.fetch(feedsFetchRequest)
        let bottles = try? self.context.fetch(bottlesFetchRequest)
        
        if emotion.status.rawValue < 4 {
            if let report = negativeInsightsForNaps(naps: naps ?? []) {
                results["naps"] = report
            }
            
            if let report = negativeInsightsForFeeds(feeds: feeds ?? []) {
                results["feeds"] = report
            }
            
            if let report = negativeInsightsForBottles(bottles: bottles ?? []) {
                results["bottle_feeds"] = report
            }
        }else {
            if let report = positiveInsightsForNaps(naps: naps ?? []) {
                results["naps"] = report
            }
            
            if let report = positiveInsightsForFeeds(feeds: feeds ?? []) {
                results["feeds"] = report
            }

            if let report = positiveInsightsForBottles(bottles: bottles ?? []) {
                results["bottle_feeds"] = report
            }
        }
        
        return results.values.count > 0 ? results : nil
    }
    
    func getTimeDetails<T: Trackable>(items: [T]) -> (count: Int, total: Duration, average: Duration) {
        guard items.count > 0 else {
            return (count: 0, total: 0, average: 0)
        }
        let duration = items.reduce(into: 0) { total, item in
            total += item.trackableUnit
        }
        
        let average = duration / Int32(items.count)
        
        return (count: items.count, total: duration, average: average)
    }
    
    func negativeInsightsForNaps(naps: [Nap]) -> [String]? {
        let details = getTimeDetails(items: naps)
        
        var reports: [String] = []
        
        if details.total > 8 {
            reports.append("over_napping")
        }
        
        if (1..<5).contains(details.total) {
            reports.append("under_napping")
        }
        
        if(naps.count > 0 && naps.filter {$0.wrappedCreatedAt.earlyEvening}.count > 0) {
            reports.append("bad_nap_times")
        }
        
        return reports.count > 0 ? reports : nil
    }
    
    func negativeInsightsForFeeds(feeds: [FeedSession]) -> [String]? {
        let details = getTimeDetails(items: feeds)
        let tenMinutes = 60 * 10 * 100 // ten minutes in miliseconds
        
        var reports: [String] = []
        
        if details.count >= 20 && details.average <= tenMinutes {
            reports.append("cluster_feeding")
        }
        reports.append("cluster_feeding")
        
        let earlyMorningFeeds = feeds.filter {$0.wrappedCreatedAt.earlyMorning}.count
        
        if earlyMorningFeeds > 4 {
            reports.append("late_nights")
        }
        reports.append("late_nights")
        
        if details.average > tenMinutes * 4 {
            reports.append("long_feeds")
        }
        
        return reports.count > 0 ? reports : nil
    }
    
    func positiveInsightsForNaps(naps: [Nap]) -> [String]? {
        let details = getTimeDetails(items: naps)
        let tenMinutes: Double = 60000
        
        var reports: [String] = []
        
        if (3...8).contains(details.count) {
            reports.append("ideal_nap_amount")
        }
        
        if ((tenMinutes * 1.5)...(tenMinutes * 6)).contains(Double(details.average)) {
            reports.append("ideal_nap_duration")
        }
        
        if(naps.allSatisfy {$0.wrappedCreatedAt.duringTheDay}) {
            reports.append("ideal_nap_times")
        }
        
        return reports.count > 0 ? reports : nil
    }
    
    func positiveInsightsForFeeds(feeds: [FeedSession]) -> [String]? {
        let details = getTimeDetails(items: feeds)
        let tenMinutes: Double = 60000
        
        var reports: [String] = []
        
        if ((tenMinutes)...(tenMinutes * 50)).contains(Double(details.average)) {
            reports.append("ideal_feeding_time")
        }
        
        let earlyMorningFeeds = feeds.filter {$0.wrappedCreatedAt.earlyMorning}.count
        if (1..<6).contains(earlyMorningFeeds) {
            reports.append("ideal_late_nights")
        }
        
        return reports.count > 0 ? reports : nil
    }
    
    func negativeInsightsForBottles(bottles: [BottleFeed]) -> [String]? {
        var reports: [String] = []
        
        let earlyMorningFeeds = bottles.filter {$0.wrappedCreatedAt.earlyMorning}.count
        
        if earlyMorningFeeds > 4 {
            reports.append("late_night_bottles")
        }
        
        return reports.count > 0 ? reports : nil
    }
    
    func positiveInsightsForBottles(bottles: [BottleFeed]) -> [String]? {
        var reports: [String] = []
        
        let earlyMorningFeeds = bottles.filter {$0.wrappedCreatedAt.earlyMorning}.count
        
        if (1..<4).contains(earlyMorningFeeds) {
            reports.append("ideal_late_night_bottles")
        }
        
        return reports.count > 0 ? reports : nil
    }
}
