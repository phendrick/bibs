//
//  StatsMonthlyView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct FeedSessionStatsMonthlyView<T: Trackable>: View {
    @ObservedObject var child: Child
    @ObservedObject var chartData: TrackableChartData<T>
    
    @State var month: Date = Date()
    @State var dateRange: ClosedRange<Date> = Date().beginningOfMonth.previousMonth...Date().endOfMonth
    
    var showThisMonthButton: Bool {
        let activeComponents = Calendar.current.dateComponents([.year, .month], from: self.month)
        let currentComponents = Calendar.current.dateComponents([.year, .month], from: Date())
        
        return activeComponents != currentComponents
    }
    
    var showPreviousMonthButton: Bool {
        true
    }
    
    var nextMonthButtonEnabled: Bool {
        return self.month < Date().beginningOfMonth
    }
    
    var previousMonthName: String {
        guard let date = Calendar.current.date(byAdding: .month, value: -1, to: self.month) else {
            return ""
        }
        
        return "\(date.getFormattedDate(format: "LLLL"))"
    }
    
    var nextMonthName: String {
        guard let date = Calendar.current.date(byAdding: .month, value: 1, to: self.month) else {
            return ""
        }
        
        return "\(date.getFormattedDate(format: "LLLL"))"
    }
    
    var activeMonthName: String {
        return self.month.getFormattedDate(format: "LLLL")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(self.activeMonthName)").font(.headline)
                    
                    Spacer()
                    
                    HStack {
                        Button("This month") {
                            self.month = Date().beginningOfMonth
                            let dateRange = self.month...self.month.endOfMonth
                            
                            self.chartData.range = dateRange
                            let _ = self.chartData.generateDataInRange()
                        }
                        .frame(width: 80)
                        .opacity(self.showThisMonthButton ? 1 : 0 ).disabled(!self.showThisMonthButton)
                        
                        HStack {
                            HStack {
                                Image(systemName: "chevron.left").scaledToFill()
                                
                                Text("\(self.previousMonthName)").onTapGesture {
                                    self.month = self.month.previousMonth.beginningOfMonth
                                    
                                    let previousMonth = self.month.previousMonth.beginningOfMonth
                                    let dateRange = previousMonth...previousMonth.endOfMonth
                                    
                                    self.chartData.range = dateRange
                                    let _ = self.chartData.generateDataInRange()
                                }
                            }.frame(width: 80)
                            
                            HStack {
                                Text("\(self.nextMonthName)").onTapGesture {
                                    self.month = self.month.nextMonth.beginningOfMonth
                                    let dateRange = self.month...self.month.endOfMonth
                                    
                                    self.chartData.range = dateRange
                                    let _ = self.chartData.generateDataInRange()
                                }
                                
                                Image(systemName: "chevron.right")
                            }.frame(width: 80)
                        }
                    }.font(.caption)
                }
                
                Divider()
                
                HStack(alignment: .bottom, spacing: 2) {
                    Spacer()
                    
                    self.chartData.data.map { chartData in
                        ForEach(chartData.data.keys.sorted(), id: \.self) { date in
                            BarChartBarView(
                                width: 8,
                                value: barValue(
                                    value:    CGFloat( chartData.data[date]!.reduce(into: 0) {$0 += $1.trackableUnit } ),
                                    maxValue: Double( chartData.max )
                                ),
                                chartHeight: 160
                            )
                        }
                    }
                    
                    Spacer()
                }
                .frame(height: 160)
                
                Divider().padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Monthly intro: \(self.chartData.data?.data.values.filter {$0.count>0}.count ?? 0)").font(.caption)
                    Text("Monthly summary: \(self.chartData.data?.data.keys.count ?? 0)").font(.caption).onTapGesture {
                        self.chartData.objectWillChange.send()
                    }
                }
            }
        }
        .animation(.linear(duration: 0.25))
        .padding()
        .foregroundColor(Color.white)
    }
}

//struct StatsMonthlyView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        
//        let child = Child(context: context)
//        child.wrappedName = "Child Name"
//        
//        return StatsMonthlyView(
//            chartData: FeedSessionChartData(child: child)
//        )
//    }
//}
