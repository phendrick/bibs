//
//  CountingStatsChartEnum.swift
//  bibs
//
//  Created by Paul Hendrick on 06/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

enum CountStatesChartDateRange {
    case today
    case week
    case month
    case dateRange(ClosedRange<Date>)
    
    var range: ClosedRange<Date>? {
        switch(self) {
        case .today: return Date().beginningOfDay...Date()
        case .week: return Date().beginningOfWeek...Date()
        case .month: return Date().beginningOfMonth...Date()
        case .dateRange(let dateRange): return dateRange
        }
    }
    
    var previous: ClosedRange<Date> {
        guard let dates = self.range else {
            let lower = Date().beginningOfWeek
            return lower...lower.endOfWeek
        }
        
        switch(self) {
            case .today: return dates.lowerBound.previousDay...dates.lowerBound.previousDay.endOfDay
            case .week: return dates.lowerBound.previousWeek...dates.lowerBound.previousWeek.endOfWeek
            case .month: return dates.lowerBound.previousMonth...dates.lowerBound.previousMonth.endOfMonth
            case .dateRange(let dateRange): return dateRange
        }
    }
    
    var next: ClosedRange<Date> {
        guard let dates = self.range else {
            let lower = Date().beginningOfWeek
            return lower...lower.endOfWeek
        }
        
        switch(self) {
            case .today: return dates.lowerBound.tomorrow...dates.lowerBound.tomorrow.endOfDay
            case .week: return dates.lowerBound.nextWeek...dates.lowerBound.nextWeek.endOfWeek
            case .month: return dates.lowerBound.nextMonth...dates.lowerBound.nextMonth.endOfMonth
            case .dateRange(let dateRange): return dateRange
        }
    }
    
    var predicate: NSPredicate {
        var dates: ClosedRange<Date>
        
        switch(self) {
            case .today:
                dates = Date().beginningOfDay...Date().endOfDay
            case .week:
                dates = Date().beginningOfWeek.endOfDay...Date().beginningOfWeek.plusWeek.endOfDay
            case .month:
                dates = Date().beginningOfMonth...Date().endOfMonth
            case .dateRange(let dateRange):
                dates = dateRange
        }
        
        return NSPredicate(
            format: "createdAt >= %@ AND createdAt <= %@",
            dates.lowerBound as NSDate, dates.upperBound as NSDate
        )
    }
}
