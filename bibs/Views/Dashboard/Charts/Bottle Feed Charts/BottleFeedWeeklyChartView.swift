//
//  BottleFeedWeeklyChartView.swift
//  bibs
//
//  Created by Paul Hendrick on 06/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct BottleFeedWeeklyChartView: View {
    var child: Child
    var fetchRequest: FetchRequest<BottleFeed>
    var results: FetchedResults<BottleFeed> { fetchRequest.wrappedValue }
    
    @State var dateRange: CountStatesChartDateRange = .week
    
    init(dateRange: CountStatesChartDateRange, sortDescriptors: [NSSortDescriptor] = [], predicates: [NSPredicate] = [], child: Child) {
        self.child = child
        
        var allPredicates = [dateRange.predicate]
        predicates.forEach { allPredicates.append($0) }
        
        let predicates = NSCompoundPredicate(
            andPredicateWithSubpredicates: allPredicates
        )
        
        self.fetchRequest = FetchRequest<BottleFeed>(entity: BottleFeed.entity(), sortDescriptors: sortDescriptors, predicate: predicates)
        self.dateRange = dateRange
    }
    
    func groupedResults() -> (data: [BottleFeed.BottleFeedType : [BottleFeed]], min: Int, max: Int) {
        var grouped = Dictionary(grouping: results) { $0.status }
        
        BottleFeed.BottleFeedType.allCases.forEach { caseType in
            if grouped[caseType] == nil {
                grouped[caseType] = []
            }
        }
        
        let max = grouped.values.max {$0.count < $1.count}?.count ?? 0
        let min = grouped.values.max {$0.count > $1.count}?.count ?? 0
        
        return (data: grouped, min: min, max: max)
    }
    
    var getMaxValue: Double {
        let max = (self.groupedResults().data.max {$0.value.count < $1.value.count}?.value.count ?? 0)
        
        return Double(max)
    }
    
    func valueFor(type: BottleFeed.BottleFeedType) -> CGFloat {
        CGFloat(self.groupedResults().data[type]?.count ?? 0)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("weekly_breakdown".localized)
            }
            
            Divider().padding(.bottom, 5)
            
            GeometryReader { outerGeometry in
                HStack(alignment: .bottom, spacing: 10) {
                    ForEach(BottleFeed.BottleFeedType.allCases, id: \.self) {bottleType in
                        GeometryReader { geometry in
                            Spacer()
                            VStack(alignment: .center) {
                                BarChartBarView(
                                    width: 20,
                                    value: barValue(
                                        value: self.valueFor(type: bottleType),
                                        maxValue: self.getMaxValue,
                                        chartSize: 150
                                    ),
                                    chartSize: 150,
                                    axis: .vertical,
                                    cornerRadius: 20,
                                    showLabel: true,
                                    label: "\(Int(self.valueFor(type: bottleType)))"
                                ).overlay(
                                    Text("\(bottleType.description)").font(.caption).frame(width: 300, alignment: .bottom)
                                    .rotationEffect(Angle(degrees: -90))
                                        .offset(x: -20)
                                )
                            }
                            .frame(width: outerGeometry.frame(in: .global).width / CGFloat(BottleFeed.BottleFeedType.allCases.count))

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

struct BottleFeedWeeklyChartView_Previews: PreviewProvider {
    static var previews: some View {
        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        let child = Child(context: context)
        
        return VStack {
            return BottleFeedWeeklyChartView(
                dateRange: .week, sortDescriptors: [], predicates: [], child: child
            )
        }
    }
}
