//
//  NappyChangeChartData.swift
//  bibs
//
//  Created by Paul Hendrick on 29/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

typealias NappyChangeChartDataOutput = (data: [Date: [NappyChange]], min: Int16, max: Int16)

class NappyChangeChartData: ObservableObject {
    @Published var data: NappyChangeChartDataOutput?
    
    var includeAllDatesInRange = true
    var child: Child
    var range: ClosedRange<Date>
    
    init(child: Child, range: ClosedRange<Date>, includeAllDatesInRange: Bool) {
        self.child = child
        self.range = range
        self.includeAllDatesInRange = includeAllDatesInRange
        self.data = generateDataInRange(range: range)
    }
    
    func generateDataInRange(range: ClosedRange<Date>) -> NappyChangeChartDataOutput {
        let allChanges = self.child.nappyChangesArray
        let changes = allChanges.filter { range.contains( $0.wrappedCreatedAt )}
        
        var data: [Date: [NappyChange]] = [:]
        
        // if we're including all dates in the given range, build the dictionary
        if includeAllDatesInRange {
            data = buildData(within: range, from: changes)
        }else {
            // if we're not including all the dates in the range, just get the data for each of the bounds
            data[range.lowerBound] = changes.filter { $0.wrappedCreatedAt.beginningOfDay == range.lowerBound.beginningOfDay}
            data[range.upperBound] = changes.filter { $0.wrappedCreatedAt.beginningOfDay == range.upperBound.beginningOfDay}
        }
        
        // from our data for this range, collect the aggregate durations from the keys
        let durations = data.mapValues { (changes) in
            changes.reduce(into: 0) { (total, change) in
                total += change.amount
            }
        }
        
        // get the min and max values for the range - we'll use these to plot the charts
        let min = durations.values.min() ?? 0
        let max = durations.values.max() ?? 0
        
        self.data = (data: data, min: min, max: max)
        return (data: data, min: min, max: max)
    }
    
    func regenerateData() {
        let _ = self.generateDataInRange(range: self.range)
        self.objectWillChange.send()
    }
    
    private func buildData(within dateRange: ClosedRange<Date>, from changes: [NappyChange]) -> [Date: [NappyChange]] {
        var nextDate: Date = dateRange.lowerBound
        
        var grouped = Dictionary(grouping: changes) {
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
