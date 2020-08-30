//
//  StatsWeeklyView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct FeedSessionStatsWeeklyView<T: Trackable>: View {
    @ObservedObject var child: Child
    @ObservedObject var chartData: TrackableChartData<T>
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("This week").font(.headline)
                
                Divider()
                
                HStack(alignment: .bottom) {
                    GeometryReader { geometry in
                        ZStack {
                            HStack(alignment: .bottom) {
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("this weeks intro").font(.caption)
                                    Text("this weeks summary").font(.caption)
                                }
                                
                                VStack {
                                    HStack(alignment: .bottom) {
                                        ForEach(0..<7, id: \.self) {index in
                                            BarChartBarView(
                                                width: 10,
                                                value: barValue(
                                                    value: CGFloat((40..<70).randomElement()!),
                                                    maxValue: 100,
                                                    chartSize: 100
                                                ),
                                                chartSize: 100,
                                                color: .white,
                                                axis: .vertical
                                            )
                                        }
                                    }
                                }
                                .frame(maxHeight: .infinity)
                                .frame(width: geometry.size.width * 0.55, alignment: .bottomTrailing)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
                .frame(height: 160)
            }
        }
        .padding()
        .foregroundColor(Color.white)
    }
}

//struct StatsWeeklyView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        
//        let child = Child(context: context)
//        child.wrappedName = "Child Name"
//        
//        return StatsWeeklyView(
//            chartData: FeedSessionChartData(child: child)
//        )
//    }
//}
