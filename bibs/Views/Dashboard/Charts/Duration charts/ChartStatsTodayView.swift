//
//  StatsTodayView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct ChartStatsTodayView<T: Trackable>: View where T: NSManagedObject {
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
    
    var dataForPreviousDate: (min: Double, max: Double, counts: ClosedRange<Int>) {
        let data = self.chartData.data?.data
        
        let min = self.chartData.data?.min ?? 0
        let max = self.chartData.data?.max ?? 0
        let counts = self.chartData.data?.counts ?? 0...0
        
        return (min: Double(min), max: Double(max), counts: counts)
    }
    
    var dataForLatestDate: (min: Double, max: Double, counts: ClosedRange<Int>) {
        let data = self.chartData.data?.data

        let min = self.chartData.data?.min ?? 0
        let max = self.chartData.data?.max ?? 0
        let counts = self.chartData.data?.counts ?? 0...0
        
        return (min: Double(min), max: Double(max), counts: counts)
    }
    
    var dailyOverviewIntro: String {
        let diff = abs( dataForPreviousDate.counts.lowerBound - dataForLatestDate.counts.upperBound )
        let ls = NSLocalizedString("%@ feed %ld increase", comment: "increase or decrease in todays feeds")
        return String.localizedStringWithFormat(ls, self.child.wrappedName, diff)
    }
    
    func feedCountLabel(count: Int) -> String {
        let ls = NSLocalizedString("%ld feeds", comment: "pluralised feeds")
        return String.localizedStringWithFormat(ls, count)
    }
    
    var maxChartValue: Double {
        return Double( max( self.dataForLatestDate.counts.max() ?? 0, self.dataForPreviousDate.counts.max() ?? 0) )
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 60) {
                VStack(alignment: .leading) {
                    Text(self.feedCountLabel(count: self.dataForLatestDate.counts.upperBound)).foregroundColor(.white).font(.headline)
                    
                    GeometryReader { geometry in
                        self.chartData.data.map { chartData in
                            ZStack(alignment: .leading) {
                                BarChartBarView(
                                    width: 40,
                                    value:  barValue(
                                                value: CGFloat(self.dataForLatestDate.counts.upperBound),
                                                maxValue: self.maxChartValue,
                                                chartSize: geometry.frame(in: .local).size.width
                                            ),
                                    chartSize: geometry.frame(in: .local).size.width,
                                    axis: .horizontal
                                )
                                .cornerRadius(5)
                                
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
                    Text(self.feedCountLabel(count: self.dataForPreviousDate.counts.lowerBound)).foregroundColor(.white).font(.headline)
                    GeometryReader { geometry in
                        self.chartData.data.map { chartData in
                            ZStack(alignment: .leading) {
                                BarChartBarView(
                                    width: 40,
                                    value:  barValue(
                                                value: CGFloat(self.dataForPreviousDate.counts.lowerBound),
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
