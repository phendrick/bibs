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
    
    var dataForPreviousDate: (min: Double, max: Double, counts: (previous: (count: Int, duration: Int32), latest: (count: Int, duration: Int32))) {
        let min = self.chartData.data?.min ?? 0
        let max = self.chartData.data?.max ?? 0
        let counts = self.chartData.data?.counts ?? (previous: (count: 0, duration: 0), latest: (count: 0, duration: 0))
        
        return (min: Double(min), max: Double(max), counts: counts)
    }
    
    var dataForLatestDate: (min: Double, max: Double, counts: (previous: (count: Int, duration: Int32), latest: (count: Int, duration: Int32))) {
        let min = self.chartData.data?.min ?? 0
        let max = self.chartData.data?.max ?? 0
        let counts = self.chartData.data?.counts ?? (previous: (count: 0, duration: 0), latest: (count: 0, duration: 0))
        
        return (min: Double(min), max: Double(max), counts: counts)
    }
    
    var dailyOverviewIntro: String {
        let diff = abs( dataForPreviousDate.counts.previous.count - dataForLatestDate.counts.latest.count )
        let ls = NSLocalizedString("%@ feed %ld increase", comment: "increase or decrease in todays feeds")
        return String.localizedStringWithFormat(ls, self.child.wrappedName, diff)
    }
    
    func dailyOverviewCountLabel(count: Int) -> String {
        let ls = NSLocalizedString("\(String(describing: T.self))_count", comment: "pluralised count")
        return String.localizedStringWithFormat(ls, count)
    }

    func dailyOverviewSummary() -> String {
        guard let chartData = self.chartData.data else {
            return ""
        }
        
        let earliestData = self.dataForPreviousDate
        let latestData   = self.dataForLatestDate
        
        let earliestDate = self.earliestDate
        let latestDate   = self.latestDate
        
        let feedDurationTime = chartData.counts.latest.duration
        
        let latestFeedToday = latestDate.isToday ? 1 : 2
        let feedCountToday  = latestDate.isToday ? 1 : 2
        let feedDuration = "for around \(feedDurationTime.formattedHoursAndMinutes)"
        
//            print(latestFeedToday, feedCount, feedDuration)
//            print(latestDay)
//            print(previousDay)

//      child fed today
//        "[Milo last fed at 2pm]. [They've fed twice today] [for around 1 hour 35 minutes in total], [which around 12 minutes more] [than at this time yesterday]"
//        "[Milo last fed at 2pm]. [They've fed 4 times today] [for around 1 hour 35 minutes in total], [which is around 12 minutes less] [than today]"
    
//      child not fed today
//        "[Milo last fed on Wednesday]. [They fed 13 times] [for around 1 hour 35 minutes in total], [which is 3 feeds and around 12 minutes more] [than yesterday]" more on latest day
//        "[Milo last fed on Wednesday]. [They fed 13 times] [for around 1 hour 35 minutes in total], [which is 3 feeds and around 12 minutes more] [than today]" more on previous day
        
        
//        let ls = NSLocalizedString("\(String(describing: T.self))_summary", comment: "pluralised count")
//        let out1 = String.localizedStringWithFormat(ls, 1, "me", "the day")
//        let out2 = String.localizedStringWithFormat(ls, 2, "me", "the day")
//        let out3 = String.localizedStringWithFormat(ls, 2, "me", "the day")
//        let out4 = String.localizedStringWithFormat(ls, 1, "me", "the day")
        
//        print(out1)
//        print(out2)
//        print(out3)
//        print(out4)
        
        return ""
    }
    
    var maxChartValue: Double {
        return Double( max( self.dataForLatestDate.counts.previous.count, self.dataForPreviousDate.counts.latest.count) )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Today".localized).font(.headline).onTapGesture {
                self.dailyOverviewSummary()
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading) {
                    Text(self.dailyOverviewCountLabel(count: self.dataForLatestDate.counts.latest.count)).foregroundColor(.white).font(.headline)
                    
                    GeometryReader { geometry in
                        self.chartData.data.map { chartData in
                            ZStack(alignment: .leading) {
                                BarChartBarView(
                                    width: 40,
                                    value:  barValue(
                                            value: CGFloat(self.dataForLatestDate.counts.latest.count),
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
                    Text(self.dailyOverviewCountLabel(count: self.dataForPreviousDate.counts.previous.count)).foregroundColor(.white).font(.headline)
                    
                    GeometryReader { geometry in
                        self.chartData.data.map { chartData in
                            ZStack(alignment: .leading) {
                                BarChartBarView(
                                    width: 40,
                                    value:  barValue(
                                                value: CGFloat(self.dataForPreviousDate.counts.previous.count),
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
                
                Text("Baby has fed 13 times today, for a total of 1 hour 12 minutes. ")
                    .offset(y: -20)
            }
        }
        .padding()
        .foregroundColor(Color.white)
    }
}
