//
//  StatsMonthlyView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct FeedSessionStatsMonthlyView<T: Trackable>: View where T: NSManagedObject {
    @ObservedObject var child: Child
    @ObservedObject var chartData: TrackableChartData<T>
    
    @State var month = Date()
    
    var showThisMonthButton: Bool {
        let activeComponents = Calendar.current.dateComponents([.year, .month], from: self.month.beginningOfMonth)
        let currentComponents = Calendar.current.dateComponents([.year, .month], from: Date())
        
        return activeComponents != currentComponents
    }
    
    var showPreviousMonthButton: Bool {
        true
    }
    
    var nextMonthButtonEnabled: Bool {
        return self.month.beginningOfMonth < Date().beginningOfMonth
    }
    
    var previousMonthName: String {
        guard let date = Calendar.current.date(byAdding: .month, value: -1, to: self.month.beginningOfMonth) else {
            return ""
        }
        
        return "\(date.getFormattedDate(format: "LLLL"))"
    }
    
    var nextMonthName: String {
        guard let date = Calendar.current.date(byAdding: .month, value: 1, to: self.month.beginningOfMonth) else {
            return ""
        }
        
        return "\(date.getFormattedDate(format: "LLLL"))"
    }
    
    var activeMonthName: String {
        return self.month.beginningOfMonth.getFormattedDate(format: "LLLL")
    }
    
    func showPreviousMonth() {
        self.month = self.month.beginningOfMonth.previousMonth
        
        let dateRange = self.month...self.month.endOfMonth
        self.chartData.range = dateRange
        self.chartData.regenerateData()
    }
    
    func showNextMonth() {
        self.month = self.month.beginningOfMonth.nextMonth
        
        let dateRange = self.month...self.month.endOfMonth
        self.chartData.range = dateRange
        self.chartData.regenerateData()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack(alignment: .firstTextBaseline) {
                    Text("\(self.activeMonthName)").font(.headline)
                    
                    Spacer()
                    
                    HStack {
                        Button("This month") {
                            self.month = Date()
                            let dateRange = self.month.beginningOfMonth...self.month.endOfMonth
                            
                            self.chartData.range = dateRange
                            self.chartData.regenerateData()
                        }
                        .frame(width: 80)
                        .opacity(self.showThisMonthButton ? 1 : 0 ).disabled(!self.showThisMonthButton)
                        
                        HStack {
                            HStack {
                                Image(systemName: "chevron.left").scaledToFill()
                                
                                Button("\(self.previousMonthName)") {
                                    self.showPreviousMonth()
                                }
                            }.frame(width: 80)
                            
                            HStack {
                                Button("\(self.nextMonthName)") {
                                    self.showNextMonth()
                                }
                                
                                Image(systemName: "chevron.right")
                            }.frame(width: 80)
                        }
                    }.font(.caption)
                }
                .animation(nil)
                
                Divider()
                
                GeometryReader { geometry in
                    self.chartData.data.map { chartData in
                        HStack(alignment: .center, spacing: 2) {
                            Spacer()
                            
                            ForEach(chartData.data.keys.sorted(), id: \.self) { date in
                                BarChartBarView(
                                    width: 10,
                                    value: barValue(
                                        value: CGFloat( (chartData.data[date] ?? 0 ) ),
                                        maxValue: Double( chartData.max ),
                                        chartSize: 180
                                    ),
                                    chartSize: 180,
                                    color: .white,
                                    axis: .vertical
                                )
                            }
                            
                            Spacer()
                        }
                        .frame(height: 220)
                        .frame(maxHeight: .infinity)
                    }
                }.frame(height: 220)
                
                Divider().padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Monthly intro: \(self.chartData.data?.data.values.count ?? 0)").font(.caption)
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
