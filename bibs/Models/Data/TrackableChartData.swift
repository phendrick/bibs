//
//  TrackableChartData.swift
//  bibs
//
//  Created by Paul Hendrick on 29/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import CoreData
import UIKit

typealias chartDataStructure = (
    data: [Date: Int32],
    counts: (previous: (count: Int, duration: Int32), latest: (count: Int, duration: Int32)),
    min: Int32,
    max: Int32,
    itemCount: Int,
    average: Int32
)
    
class TrackableChartData<T: Trackable>: ObservableObject where T: NSManagedObject {
    @Published var data: chartDataStructure?
    
    var includeAllDatesInRange = true
    var child: Child
    var range: ClosedRange<Date>
    var moc: NSManagedObjectContext 
    var predicates: [NSPredicate] = []
    
    init(child: Child, range: ClosedRange<Date>, includeAllDatesInRange: Bool, predicates: [NSPredicate] = [] ) {
        self.child = child
        self.range = range
        self.includeAllDatesInRange = includeAllDatesInRange
        self.moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        print(self.range)
        
        self.regenerateData()
    }
    
    private func fetchData() -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        let dateFromPredicate = NSPredicate(format: "createdAt >= %@", range.lowerBound as NSDate)
        let dateToPredicate   = NSPredicate(format: "createdAt < %@",  range.upperBound as NSDate)
        let childPredicate    = NSPredicate(format: "child = %@", self.child)
        
        var predicates = [dateFromPredicate, dateToPredicate, childPredicate]
        
        self.predicates.forEach {
            predicates.append($0)
        }
        
        let datePredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: predicates
        )
        
        fetchRequest.predicate = datePredicate
        
        let results = try? self.moc.fetch(fetchRequest)
        
        return results ?? []
    }
    
    func generateDataInRange() -> (data: [Date: Int32], counts: (previous: (count: Int, duration: Int32), latest: (count: Int, duration: Int32)), min: Int32, max: Int32, itemCount: Int, average: Int32)? {
        let items = self.fetchData()
        
        //let items: [T] = [] //self.allItems.filter { self.range.contains( $0.wrappedCreatedAt )}
        var data: [Date: Int32] = [:]
        var counts: (previous: (count: Int, duration: Int32), latest: (count: Int, duration: Int32)) = (previous: (count: 0, duration: 0), latest: (count: 0, duration: 0))
        
        // if we're including all dates in the given range, build the dictionary
        if includeAllDatesInRange {
            data = buildData(within: self.range, from: items) as [Date: Int32]
        }else {
            let lowerBoundResults = items.filter { $0.wrappedCreatedAt.beginningOfDay == self.range.lowerBound.beginningOfDay}
            let upperBoundResults = items.filter { $0.wrappedCreatedAt.beginningOfDay == self.range.upperBound.beginningOfDay}
            
            let lowerBoundDuration = lowerBoundResults.reduce(into: 0) {$0 += $1.trackableUnit}
            let upperBoundDuration = upperBoundResults.reduce(into: 0) {$0 += $1.trackableUnit}
            
            counts = (previous: (count: lowerBoundResults.count, duration: lowerBoundDuration), latest: (count: upperBoundResults.count, duration: upperBoundDuration))
            
            // if we're not including all the dates in the range, just get the data for each of the bounds
            data[self.range.lowerBound] = lowerBoundResults.reduce(into: 0) {$0 += $1.trackableUnit}
            data[self.range.upperBound] = upperBoundResults.reduce(into: 0) {$0 += $1.trackableUnit}
        }
        
        // get the min and max values for the range - we'll use these to plot the charts
        let min = data.values.min() ?? 0
        let max = data.values.max() ?? 0
        
        return (data: data, counts: counts, min: min, max: max, itemCount: items.count, average: 0)
    }
    
    func regenerateData() {
        Dispatch.background {
            let data = self.generateDataInRange()
            
            Dispatch.main {
                self.data = data
                self.objectWillChange.send()
            }
        }
    }
    
    private func buildData(within dateRange: ClosedRange<Date>, from sessions: [T]) -> [Date: Int32] {
        var nextDate: Date = dateRange.lowerBound

        let grouped = Dictionary(grouping: sessions) {
            $0.wrappedCreatedAt.beginningOfDay
        }
        
        var groupedValues: [Date: Int32] = [:]
        
        repeat {
            if let index = grouped.index(forKey: nextDate.beginningOfDay) {
                groupedValues[nextDate.beginningOfDay] = grouped[index].value.reduce(into: 0) {$0 += $1.trackableUnit}
            }else {
                groupedValues[nextDate.beginningOfDay] = 0
            }

            if let date = Calendar.current.date(byAdding: .day, value: 1, to: nextDate, wrappingComponents: false) {
                nextDate = date
            }
        }while(nextDate < dateRange.upperBound)

        return groupedValues
    }
}
