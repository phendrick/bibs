//
//  CountStatesChartView.swift
//  bibs
//
//  Created by Paul Hendrick on 01/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct NappyChangeDailyChartView: View {
    @Environment(\.managedObjectContext) var moc
    var child: Child
    var month = Date()
    
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
    
    var fetchRequest: FetchRequest<NappyChange>
    var results: FetchedResults<NappyChange> { fetchRequest.wrappedValue }
    var dateRange: CountStatesChartDateRange = .today
    
    init(range: CountStatesChartDateRange, sortDescriptors: [NSSortDescriptor] = [], predicates: [NSPredicate] = [], child: Child) {
        self.dateRange = range
        
        var allPredicates = [range.predicate]
        predicates.forEach { allPredicates.append($0) }
        
        let predicates = NSCompoundPredicate(
            andPredicateWithSubpredicates: allPredicates
        )
        
        self.child = child
        
        self.fetchRequest = FetchRequest<NappyChange>(entity: NappyChange.entity(), sortDescriptors: sortDescriptors, predicate: predicates)
    }
    
    func groupedResults() -> (data: [NappyChange.StatusType : [NappyChange]], min: Int, max: Int) {
        var grouped = Dictionary(grouping: results) { $0.status }
        
        NappyChange.NappyChangeType.allCases.forEach { caseType in
            if grouped[caseType] == nil {
                grouped[caseType] = []
            }
        }
        
        let max = grouped.values.max {$0.count < $1.count}?.count ?? 0
        let min = grouped.values.max {$0.count > $1.count}?.count ?? 0
        
        return (data: grouped, min: min, max: max)
    }
    
    let colors: [Color] = [
        .red, .green, .orange, .pink, .yellow, .purple, .blue
    ]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Today")

                Divider()
                    .padding(.bottom, 5)

                ForEach(NappyChange.NappyChangeType.allCases, id: \.self) {nappyType in
                    GeometryReader { geometry in
                        VStack(alignment: .leading) {
                            Text("\(Int.random(in: 2...10)) \(nappyType.description) nappies")
                                .font(.caption)

                            BarChartBarView(
                                width: 20,
                                value: barValue(
                                    value: CGFloat.random(in: 50...200),
                                    maxValue: 200
                                ),
                                chartSize: geometry.frame(in: .global).width,
                                axis: .horizontal,
                                cornerRadius: 30,
                                barValue: geometry.frame(in: .global).width
                            )
                        }

                        Spacer()
                    }.frame(height: 50, alignment: .leading)
                }

                Spacer()
            }
        }
        .padding()
        .foregroundColor(Color.white)
    }
}

struct CountStatesChartView_Previews: PreviewProvider {
    static var previews: some View {
        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let child = Child(context: context)
        
        return NappyChangeDailyChartView(
            range: .month,
            child: child
        ).previewLayout(.fixed(width: 300, height: 500))
    }
}
