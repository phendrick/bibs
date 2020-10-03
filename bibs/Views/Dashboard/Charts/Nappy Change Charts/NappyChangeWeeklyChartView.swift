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
    
    func groupedResults() -> (data: [NappyChange.NappyChangeType : [NappyChange]], min: Int, max: Int) {
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
    
    var getMaxValue: Double {
        let max = (self.groupedResults().data.max {$0.value.count < $1.value.count}?.value.count ?? 0)
        
        return Double(max)
    }
    
    func valueFor(type: NappyChange.NappyChangeType) -> CGFloat {
        CGFloat(self.groupedResults().data[type]?.count ?? 0)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Weekly Breakdown".localized)
            Divider().padding(.bottom, 5)
            
            GeometryReader { outerGeometry in
                HStack(alignment: .bottom, spacing: 10) {
                    ForEach(NappyChange.NappyChangeType.allCases, id: \.self) {nappyType in
                        GeometryReader { geometry in
                            Spacer()
                            VStack(alignment: .center) {
                                BarChartBarView(
                                    width: 20,
                                    value: barValue(
                                        value: self.valueFor(type: nappyType),
                                        maxValue: self.getMaxValue,
                                        chartSize: 150
                                    ),
                                    chartSize: 150,
                                    axis: .vertical,
                                    cornerRadius: 10,
                                    showLabel: true,
                                    label: "\(Int(self.valueFor(type: nappyType)))"
                                ).overlay(
                                    Text("\(nappyType.description)").font(.caption).frame(width: 300, alignment: .bottom)
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
            .frame(height: 180)
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
