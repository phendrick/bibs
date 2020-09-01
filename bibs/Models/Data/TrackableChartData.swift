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
    
class TrackableChartData<T: Trackable>: ObservableObject where T: NSManagedObject {
    @Published var data: (data: [Date: Int32], min: Int32, max: Int32, average: Int32)?
    
    var includeAllDatesInRange = true
    var child: Child
    var range: ClosedRange<Date>
    var moc: NSManagedObjectContext 
    
    init(child: Child, range: ClosedRange<Date>, includeAllDatesInRange: Bool) {
        self.child = child
        self.range = range
        self.includeAllDatesInRange = includeAllDatesInRange
        self.moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        self.regenerateData()
    }
    
    private func fetchData() -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        let dateFromPredicate = NSPredicate(format: "createdAt >= %@", range.lowerBound as NSDate)
        let dateToPredicate   = NSPredicate(format: "createdAt < %@",  range.upperBound as NSDate)

        let datePredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [dateFromPredicate, dateToPredicate]
        )
        fetchRequest.predicate = datePredicate
        
        let results = try? self.moc.fetch(fetchRequest)
        
        return results ?? []
    }
    
    func generateDataInRange() -> (data: [Date: Int32], min: Int32, max: Int32, average: Int32)? {
        let items = self.fetchData()
        
        //let items: [T] = [] //self.allItems.filter { self.range.contains( $0.wrappedCreatedAt )}
        var data: [Date: Int32] = [:]
        
        // if we're including all dates in the given range, build the dictionary
        if includeAllDatesInRange {
            data = buildData(within: self.range, from: items) as [Date: Int32]
        }else {
            // if we're not including all the dates in the range, just get the data for each of the bounds
            data[self.range.lowerBound] = items.filter { $0.wrappedCreatedAt.beginningOfDay == self.range.lowerBound.beginningOfDay}.reduce(into: 0) {$0 += $1.trackableUnit}
            data[self.range.upperBound] = items.filter { $0.wrappedCreatedAt.beginningOfDay == self.range.upperBound.beginningOfDay}.reduce(into: 0) {$0 += $1.trackableUnit}
        }
        
        // get the min and max values for the range - we'll use these to plot the charts
        let min = data.values.min() ?? 0
        let max = data.values.max() ?? 0
        
        return (data: data, min: min, max: max, average: 0)
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
