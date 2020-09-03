//
//  StatsWeeklyView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct ChartStatsWeeklyView<T: Trackable>: View where T: NSManagedObject {
    @ObservedObject var child: Child
    @ObservedObject var chartData: TrackableChartData<T>
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("This week".localized).font(.headline)
                
                Divider()
                
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("So far this week Baby has fed 38 times for a total of around 3 hours 48 minutes and 13 seconds. ")
                                .font(.body)
                        }
                        
                        Spacer()
                        
                        HStack {
                            HStack {
                                self.chartData.data.map { chartData in
                                    ForEach(chartData.data.keys.sorted(), id: \.self) { date in
                                        BarChartBarView(
                                            width: 10,
                                            value: barValue(
                                                value: CGFloat( (chartData.data[date] ?? 0 ) ),
                                                maxValue: Double( chartData.max ),
                                                chartSize: 130
                                            ),
                                            chartSize: 130,
                                            color: .white,
                                            axis: .vertical
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.leading, 30)
                        .layoutPriority(10)
                    }
                }.frame(height: 150)
            }
        }
        .padding()
        .foregroundColor(Color.white)
    }
}
