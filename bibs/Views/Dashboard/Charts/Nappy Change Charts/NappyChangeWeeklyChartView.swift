//
//  NappyChangeWeeklyChartView.swift
//  bibs
//
//  Created by Paul Hendrick on 01/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct NappyChangeWeeklyChartView: View {
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
        VStack(alignment: .leading) {
            Text("This Week")
            Divider().padding(.bottom, 5)
            
            GeometryReader { outerGeometry in
                HStack(spacing: 10) {
                    ForEach(NappyChange.NappyChangeType.allCases, id: \.self) {nappyType in
                        GeometryReader { geometry in
                            Spacer()
                            VStack(alignment: .center) {
                                BarChartBarView(
                                    width: 20,
                                    value: barValue(
                                        value: CGFloat.random(in: 50...200),
                                        maxValue: 200
                                    ),
                                    chartSize: 200,
                                    axis: .vertical,
                                    cornerRadius: 30,
                                    barValue: geometry.frame(in: .global).width
                                ).overlay(
                                    Text("\(Int.random(in: 2...10)) \(nappyType.description) nappies").font(.caption).frame(width: 300, alignment: .bottom)
                                    .rotationEffect(Angle(degrees: -90))
                                        .offset(x: -20)
                                )
                            }
                            .frame(width: outerGeometry.frame(in: .global).width / CGFloat(NappyChange.NappyChangeType.allCases.count))

                            Spacer()
                        }.frame(alignment: .leading)
                    }
                }
            }
        }
        .padding()
        .foregroundColor(Color.white)
        .animation(nil)
    }
}

struct NappyChangeWeeklyChartView_Previews: PreviewProvider {
    static var previews: some View {
        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let child = Child(context: context)
        
        return NappyChangeWeeklyChartView(
            range: .month,
            child: child
        ).previewLayout(.fixed(width: 420, height: 500))
        .background(Color.gray)
    }
}
