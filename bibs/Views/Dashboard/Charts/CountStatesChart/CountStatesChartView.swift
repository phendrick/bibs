//
//  CountStatesChartView.swift
//  bibs
//
//  Created by Paul Hendrick on 01/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

typealias TrackableStatusType = CaseIterable & Hashable & TrackableStatus

struct CountStatesChartView<T: Trackable, U: TrackableStatusType>: View where T: NSManagedObject, U.AllCases == Array<U> {
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
    
    @Environment(\.managedObjectContext) var moc
    @State var month = Date()
    
    var fetchRequest: FetchRequest<T>
    var results: FetchedResults<T> { fetchRequest.wrappedValue }
    var dateRange: CountStatesChartDateRange = .today
    
    init(range: CountStatesChartDateRange, sortDescriptors: [NSSortDescriptor] = [], predicates: [NSPredicate] = []) {
        self.dateRange = range
        
        var allPredicates = [range.predicate]
        predicates.forEach { allPredicates.append($0) }
        
        let predicates = NSCompoundPredicate(
            andPredicateWithSubpredicates: allPredicates
        )
        
        self.fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: predicates)
    }
    
    func groupedResults() -> [T.StatusType : [T]] {
        var grouped = Dictionary(grouping: results) { $0.status }
        
        print(grouped)
        
        U.self.allCases.forEach { caseType in
            // todo - figure out what this is all about
            let key = caseType as! Dictionary<T.StatusType, [FetchedResults<T>.Element]>.Keys.Element
            
            if grouped[key] == nil {
                grouped[key] = []
            }
        }
        
        return grouped
    }
    
    var body: some View {
        VStack {
            ForEach(Array(U.allCases), id: \.self) { key in
                Text("OK")
            }
        }
    }
}

//struct CountStatesChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        CountStatesChartView()
//    }
//}
