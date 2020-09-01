//
//  StatsTodayView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct FeedSessionStatsTodayView<T: Trackable>: View where T: NSManagedObject {
    @ObservedObject var child: Child
    @ObservedObject var chartData: TrackableChartData<T>
    
    var previousDaysChartLabel: String {
        if chartData.range.lowerBound.isYesterday {
            return NSLocalizedString("Yesterday", comment: "")
        }else {
            return chartData.range.lowerBound.getFormattedDate(format: "EEEE, MMMM d")
        }
    }
    
    var latestDate: Date {
        return self.chartData.data?.data.keys.sorted().last ?? Date()
    }
    
    var earliestDate: Date {
        self.chartData.data?.data.keys.sorted().first ?? Date()
    }
    
    func labelForDate(date: Date) -> String {
        if date.isToday {
            return NSLocalizedString("Today", comment: "")
        }else if date.isYesterday {
            return NSLocalizedString("Yesterday", comment: "")
        }else {
            return date.getFormattedDate(format: "EEEE, MMMM d")
        }
    }
    
    var multipleDaysAvailable: Bool {
        let dateComponents = self.chartData.data?.data.keys.compactMap {
            Calendar.current.dateComponents([.day, .month, .year], from: $0)
        }
        
        return dateComponents?.count ?? 0 > 1
    }
    
    var dataForPreviousDate: (min: Double, max: Double, count: Int) {
        let data = self.chartData.data?.data
        
        let min = self.chartData.data?.min ?? 0
        let max = self.chartData.data?.max ?? 0
        
        return (min: Double(min), max: Double(max), count: data?.count ?? 0)
    }
    
    var dataForLatestDate: (min: Double, max: Double, count: Int) {
        let data = self.chartData.data?.data

        let min = self.chartData.data?.min ?? 0
        let max = self.chartData.data?.max ?? 0
        
        return (min: Double(min), max: Double(max), count: data?.count ?? 0)
    }
    
    var dailyOverviewIntro: String {
        let diff = abs( dataForPreviousDate.count - dataForLatestDate.count )
        let ls = NSLocalizedString("%@ feed %ld increase", comment: "increase or decrease in todays feeds")
        return String.localizedStringWithFormat(ls, self.child.wrappedName, diff)
    }
    
    func feedCountLabel(count: Int) -> String {
        let ls = NSLocalizedString("%ld feeds", comment: "pluralised feeds")
        return String.localizedStringWithFormat(ls, count)
    }
    
    var maxChartValue: Double {
        return Double( max( self.dataForLatestDate.count, self.dataForPreviousDate.count) )
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 60) {
                VStack(alignment: .leading) {
                    Text("Hello").foregroundColor(.white).font(.headline)
                    GeometryReader { geometry in
                        self.chartData.data.map { chartData in
                            ZStack(alignment: .leading) {
                                BarChartBarView(
                                    width: 40,
                                    value:  barValue(
                                                value: CGFloat(self.dataForLatestDate.count),
                                                maxValue: self.maxChartValue,
                                                chartSize: geometry.frame(in: .local).size.width
                                            ),
                                    chartSize: geometry.frame(in: .local).size.width,
                                    axis: .horizontal
                                ).cornerRadius(5)
                                
                                Text(self.labelForDate(date: self.latestDate))
                                    .padding(5)
                                    .foregroundColor(self.child.theme.0)
                                    .font(.caption)
                            }.frame(width: geometry.frame(in: .global).size.width)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    Text(self.feedCountLabel(count: self.dataForPreviousDate.count)).foregroundColor(.white).font(.headline)
                    GeometryReader { geometry in
                        self.chartData.data.map { chartData in
                            ZStack(alignment: .leading) {
                                BarChartBarView(
                                    width: 40,
                                    value:  barValue(
                                                value: CGFloat(self.dataForPreviousDate.count),
                                                maxValue: self.maxChartValue,
                                                chartSize: geometry.frame(in: .local).size.width
                                            ),
                                    chartSize: geometry.frame(in: .local).size.width,
                                    axis: .horizontal
                                ).cornerRadius(5)
                                
                                Text(self.labelForDate(date: self.earliestDate))
                                    .padding(5)
                                    .foregroundColor(self.child.theme.0)
                                    .font(.caption)
                            }.frame(width: geometry.frame(in: .global).size.width)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }.padding()
        }
    }
}
