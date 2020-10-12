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
    /// get 'todays' overview of activity
    func completedFeedsWithinRange(dateRange: Range<Date>) -> [FeedSession] {
        return self.feedSessionsArray.filter {
            $0.status == .complete && dateRange.contains($0.wrappedCreatedAt)
        }
    }
    
    enum TrackableDataDateRange {
        case today
        case yesterday
        case week
        case month
        
        var dateRange: Range<Date> {
            switch(self) {
                case .today: return Date().beginningOfDay..<Date().endOfDay
                case .yesterday: return Date().dayAgo.beginningOfDay..<Date().beginningOfDay.advanced(by: -1)
                case .week:  return Date().weekAgo..<Date().endOfDay
                case .month: return Date().beginningOfMonth..<Date().endOfMonth
            }
        }
    }
}
