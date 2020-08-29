//
//  StatsTodayView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct BottleFeedStatsTodayView: View {
    @ObservedObject var child: Child
    @ObservedObject var chartData: FeedSessionChartData
    
    var previousDaysChartLabel: String {
        if chartData.range.lowerBound.isYesterday {
            return NSLocalizedString("Yesterday", comment: "")
        }else {
            return chartData.range.lowerBound.getFormattedDate(format: "EEEE, MMMM d")
        }
    }
    
    var latestDate: Date {
        self.chartData.data?.data.keys.sorted().last ?? Date()
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
        let data = self.chartData.data?.data[earliestDate] ?? []
        let min = data.map { $0.duration }.min() ?? 0
        let max = data.map { $0.duration }.max() ?? 0
        
        return (min: Double(min), max: Double(max), count: data.count)
    }
    
    var dataForLatestDate: (min: Double, max: Double, count: Int) {
        let data = self.chartData.data?.data[latestDate] ?? []
        let min = data.map { $0.duration }.min() ?? 0
        let max = data.map { $0.duration }.max() ?? 0
        
        return (min: Double(min), max: Double(max), count: data.count)
    }
    
    var dailyOverviewIntro: String {
//        var format: String
//
//        if dataForPreviousDate.count > dataForLatestDate.count || dataForPreviousDate.count == dataForLatestDate.count {
//            format = "feed count increase"
//        }else {
//            format = "feed count decrease"
//        }
        
        let diff = abs( dataForPreviousDate.count - dataForLatestDate.count )
        let ls = NSLocalizedString("%@ feed %ld increase", comment: "increase or decrease in todays feeds")
        return String.localizedStringWithFormat(ls, self.child.wrappedName, diff)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading, spacing: 40) {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text("\(self.dataForLatestDate.count)").font(.headline)
                            Text("feeds").font(.subheadline)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                BarChartBarView(
                                    width: 30,
                                    value:  barValue(value: CGFloat(self.dataForLatestDate.count), maxValue: Double( max( self.dataForLatestDate.count, self.dataForPreviousDate.count) ), chartHeight: geometry.size.width ),
                                    chartHeight: geometry.size.width,
                                    color: .orange,
                                    axis: .horizontal
                                )
                                
                                Text(self.labelForDate(date: self.latestDate)).padding(5).font(.caption)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("\(self.dataForPreviousDate.count)").font(.headline)
                            Text("feeds").font(.subheadline)
                        }
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                BarChartBarView(
                                    width: 30,
                                    value:  barValue(value: CGFloat(self.dataForPreviousDate.count), maxValue: Double( max( self.dataForLatestDate.count, self.dataForPreviousDate.count) ), chartHeight: geometry.size.width ),
                                    chartHeight: geometry.size.width,
                                    color: Color(UIColor.systemFill).opacity(0.5),
                                    axis: .horizontal
                                )

                                Text(self.labelForDate(date: self.earliestDate)).padding(5).font(.caption)
                            }
                        }.frame(height: 30, alignment: .leading)
                        
                        Spacer()
                    }
                }
                
                HStack(alignment: .bottom) {
                    GeometryReader { geometry in
                        ZStack {
                            HStack(alignment: .lastTextBaseline) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(self.dailyOverviewIntro).font(.subheadline)
                                    Text("The longest feed is 18 minutes 13 seconds, which is 1 minute longer than the average from yesterday. ").font(.caption)
                                }
                                
                                VStack {
                                    HStack(alignment: .bottom) {
                                        ForEach(30...41, id: \.self) {value in
                                            BarChartBarView(
                                                width: 2,
                                                value: barValue(value: CGFloat( value ), maxValue: 41, chartHeight: 100),
                                                chartHeight: 100
                                            )
                                        }
                                    }
                                }
                                .frame(maxHeight: 120)
                                .frame(width: geometry.size.width * 0.5, alignment: .bottomTrailing)
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

//struct StatsTodayView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        
//        let child = Child(context: context)
//        child.wrappedName = "Child Name"
//        
//        return StatsTodayView(
//            title: "Feeding Morty",
//            child: child,
//            profile: ProfileObserver.shared,
//            chartData: FeedSessionChartData(child: child)
//        )
//    }
//}
