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
    
    var fetchRequest: FetchRequest<NappyChange>
    var results: FetchedResults<NappyChange> { fetchRequest.wrappedValue }
    @State var dateRange: CountStatesChartDateRange = .week
    
    init(dateRange: CountStatesChartDateRange, sortDescriptors: [NSSortDescriptor] = [], predicates: [NSPredicate] = [], child: Child) {
        self.child = child
        
        var allPredicates = [dateRange.predicate]
        predicates.forEach { allPredicates.append($0) }
        
        let predicates = NSCompoundPredicate(
            andPredicateWithSubpredicates: allPredicates
        )
        
        self.fetchRequest = FetchRequest<NappyChange>(entity: NappyChange.entity(), sortDescriptors: sortDescriptors, predicate: predicates)
        self.dateRange = dateRange
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
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Today")

                Divider()
                    .padding(.bottom, 5)

                ForEach(NappyChange.NappyChangeType.allCases, id: \.self) {nappyType in
                    GeometryReader { geometry in
                        VStack(alignment: .leading) {
                            Text("\(nappyType.description) nappies")
                                .font(.caption)

                            BarChartBarView(
                                width: 28,
                                value: barValue(
                                    value: self.valueFor(type: nappyType),
                                    maxValue: self.getMaxValue,
                                    chartSize: geometry.frame(in: .local).size.width
                                ),
                                chartSize: geometry.frame(in: .local).size.width,
                                axis: .horizontal,
                                cornerRadius: 10
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
            dateRange: .month,
            child: child
        ).previewLayout(.fixed(width: 300, height: 500))
    }
}
