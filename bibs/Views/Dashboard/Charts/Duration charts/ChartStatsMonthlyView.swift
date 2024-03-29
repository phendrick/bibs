//
//  StatsMonthlyView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct ChartStatsMonthlyView<T: Trackable>: View where T: NSManagedObject {
    @ObservedObject var child: Child
    @ObservedObject var chartData: TrackableChartData<T>
    
    @State var month = Date()
    
    var useRawValueForChartData: Bool = false
    
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
    
    func valueForData(data: [Date:Int32]) -> String {
        if self.useRawValueForChartData {
            return String(data.reduce(into: 0) {$0 += $1.value})
        }else {
            return data.reduce(into: 0) {$0 += $1.value}.toFormattedString
        }
    }
    
    func showLabel(date: Date) -> Bool {
        let day = Calendar.current.component(.day, from: date)
        let lastDay = Calendar.current.component(.day, from: date.endOfMonth)
        
        guard day == 1 || day == lastDay else {
            return false
        }
        
        return true
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack(alignment: .lastTextBaseline) {
                    HStack(alignment: .lastTextBaseline) {
                        Text("\(self.activeMonthName)")
                            .font(.subheadline)
                        
                        Button("This month") {
                            self.month = Date()
                            let dateRange = self.month.beginningOfMonth...self.month.endOfMonth
                            
                            self.chartData.range = dateRange
                            self.chartData.regenerateData()
                        }
                        .font(.caption)
                        .opacity(self.showThisMonthButton ? 1 : 0 ).disabled(!self.showThisMonthButton)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        HStack {
                            Image(systemName: "chevron.left").scaledToFill()
                            
                            Button("\(self.previousMonthName)") {
                                self.showPreviousMonth()
                            }
                        }
                        
                        HStack {
                            Button("\(self.nextMonthName)") {
                                self.showNextMonth()
                            }
                            
                            Image(systemName: "chevron.right")
                        }
                    }.font(.caption)
                }
                .animation(nil)
                
                Divider()
                
                GeometryReader { geometry in
                    self.chartData.data.map { chartData in
                        HStack(alignment: .top, spacing: 4) {
                            Spacer()
                            
                            ForEach(chartData.data.keys.sorted(), id: \.self) { date in
                                BarChartBarView(
                                    width: 5,
                                    value: barValue(
                                        value: CGFloat( (chartData.data[date] ?? 0 ) ),
                                        maxValue: Double( chartData.max ),
                                        chartSize: 180
                                    ),
                                    chartSize: 180,
                                    color: .white,
                                    axis: .vertical,
                                    cornerRadius: 5,
                                    showLabel: showLabel(date: date),
                                    label: String(Calendar.current.component(.day, from: date))
                                )
                            }
                            
                            Spacer()
                        }
                        .padding(0)
                        .frame(height: 220)
                        .frame(maxHeight: .infinity)
                    }
                }.frame(height: 220)
                
                VStack(alignment: .leading, spacing: 5) {
                    if (self.chartData.data?.itemCount ?? 0) > 0 {
                        self.chartData.data.map { chartData in
                            Text(
                                String.localizedStringWithFormat(
                                    NSLocalizedString("\(String(describing: T.self))_monthly_summary", comment: "\(String(describing: T.self)) monthly summary"),
                                    self.month.getFormattedDate(format: "LLLL"),
                                    self.child.wrappedName,
                                    self.month.isThisMonth ? 0 : 1,
                                    chartData.itemCount,
                                    valueForData(data: chartData.data),
                                    "ml"
                                )
                            )
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.body)
                            .animation(nil)
                            .minimumScaleFactor(0.75)
                        }
                    }else {
                        Text("no_data".localized)
                    }
                }
            }
        }
        .animation(.linear(duration: 0.25))
        .padding()
        .foregroundColor(Color.white)
    }
}
