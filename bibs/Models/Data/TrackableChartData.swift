//
//  TrackableChartData.swift
//  bibs
//
//  Created by Paul Hendrick on 29/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

class TrackableChartData<T: Trackable>: ObservableObject {
    @Published var data: (data: [Date: [T]], min: Int32, max: Int32, average: Int32)?
    
    var includeAllDatesInRange = true
    var child: Child
    var range: ClosedRange<Date>
    var allItems: [T]
    
    init(child: Child, range: ClosedRange<Date>, includeAllDatesInRange: Bool, allItems: [T]) {
        self.child = child
        self.range = range
        self.includeAllDatesInRange = includeAllDatesInRange
        self.allItems = allItems
        
        self.regenerateData()
    }
    
    func generateDataInRange() -> (data: [Date: [T]], min: Int32, max: Int32, average: Int32)? {
        let items = self.allItems.filter { self.range.contains( $0.wrappedCreatedAt )}
        var data: [Date: [T]] = [:]
        
        // if we're including all dates in the given range, build the dictionary
        if includeAllDatesInRange {
            data = buildData(within: self.range, from: items) as [Date: [T]]
        }else {
            // if we're not including all the dates in the range, just get the data for each of the bounds
            data[self.range.lowerBound] = items.filter { $0.wrappedCreatedAt.beginningOfDay == self.range.lowerBound.beginningOfDay}
            data[self.range.upperBound] = items.filter { $0.wrappedCreatedAt.beginningOfDay == self.range.upperBound.beginningOfDay}
        }
        
        // from our data for this range, collect the aggregate durations from the keys
        let allValues = data.mapValues { (items) in
            items.reduce(into: 0) { (total, item) in
                total += item.trackableUnit
            }
        }
        
        // get the min and max values for the range - we'll use these to plot the charts
        let min = allValues.values.min() ?? 0
        let max = allValues.values.max() ?? 0
        let average = allValues.values.reduce(into: 0){$0+=$1} / Int32(allValues.count)
        
        return (data: data, min: min, max: max, average: average)
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
    
    private func buildData(within dateRange: ClosedRange<Date>, from sessions: [T]) -> [Date: [T]] {
        var nextDate: Date = dateRange.lowerBound
        
        var grouped = Dictionary(grouping: sessions) {
            $0.wrappedCreatedAt.beginningOfDay
        }
        
        repeat {
            if let _ = grouped.index(forKey: nextDate.beginningOfDay) {
            }else {
                grouped[nextDate.beginningOfDay] = []
            }
            
            if let date = Calendar.current.date(byAdding: .day, value: 1, to: nextDate, wrappingComponents: false) {
                nextDate = date
            }
        }while(nextDate < dateRange.upperBound)
        
        return grouped
    }
}
