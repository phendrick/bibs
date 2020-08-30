//
//  StatsTodayView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct FeedSessionStatsTodayView<T: Trackable>: View {
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
        let data = self.chartData.data?.data[earliestDate] ?? []
        let min = data.map { $0.trackableUnit }.min() ?? 0
        let max = data.map { $0.trackableUnit }.max() ?? 0
        
        return (min: Double(min), max: Double(max), count: data.count)
    }
    
    var dataForLatestDate: (min: Double, max: Double, count: Int) {
        let data = self.chartData.data?.data[latestDate] ?? []
        let min = data.map { $0.trackableUnit }.min() ?? 0
        let max = data.map { $0.trackableUnit }.max() ?? 0
        
        return (min: Double(min), max: Double(max), count: data.count)
    }
    
    var dailyOverviewIntro: String {
        let diff = abs( dataForPreviousDate.count - dataForLatestDate.count )
        let ls = NSLocalizedString("%@ feed %ld increase", comment: "increase or decrease in todays feeds")
        return String.localizedStringWithFormat(ls, self.child.wrappedName, diff)
    }
    
    var maxChartValue: Double {
        let maxVal = Double( max( self.dataForLatestDate.count, self.dataForPreviousDate.count) )
        return 8
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 60) {
                VStack(alignment: .leading) {
                    Text("Hello").foregroundColor(.white).font(.headline)
                    GeometryReader { geometry in
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
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    Text("Hello").foregroundColor(.white).font(.headline)
                    GeometryReader { geometry in
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
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                
            }.padding()
        }
    }
    
    var body2: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                
                VStack {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            BarChartBarView(
                                width: 30,
                                value:  barValue(
                                            value: CGFloat(self.dataForPreviousDate.count),
                                            maxValue: self.maxChartValue,
                                            chartSize: geometry.frame(in: .global).size.width
                                        ),
                                chartSize: geometry.frame(in: .global).size.width,
                                color: Color.green,
                                axis: .horizontal
                            ).onTapGesture {
                                print(geometry)
                            }

                            Text("Chart Label").padding(5).font(.caption)
                        }.frame(width: geometry.frame(in: .global).size.width)
                    }
                }.frame(maxWidth: .infinity)
                
//                VStack(alignment: .leading, spacing: 5) {
//                    HStack(alignment: .firstTextBaseline) {
//                        Text("\(self.dataForPreviousDate.count)").font(.headline)
//                        Text("feeds").font(.subheadline)
//                    }
//
//                    GeometryReader { geometry in
//                        ZStack(alignment: .leading) {
//                            BarChartBarView(
//                                width: 30,
//                                value:  barValue(
//                                            value: CGFloat(self.dataForPreviousDate.count),
//                                            maxValue: Double(
//                                                max( self.dataForLatestDate.count, self.dataForPreviousDate.count)
//                                            ),
//                                            chartSize: geometry.frame(in: .global).size.width
//                                        ),
//                                chartSize: geometry.frame(in: .global).size.width,
//                                color: Color.green,
//                                axis: .horizontal
//                            ).onTapGesture {
//                                print(geometry)
//                            }
//
//                            Text(self.labelForDate(date: self.earliestDate)).padding(5).font(.caption)
//                        }.frame(width: geometry.frame(in: .global).size.width)
//                    }
//                }
//                .frame(height: 80)
//                .background(Color.blue)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Test")
//                    VStack(alignment: .leading, spacing: 5) {
//                        HStack(alignment: .firstTextBaseline) {
//                            Text("\(self.dataForLatestDate.count)").font(.headline)
//                            Text("feeds").font(.subheadline)
//                        }
//
//                        GeometryReader { geometry in
//                            ZStack(alignment: .leading) {
//                                BarChartBarView(
//                                    width: 30,
//                                    value: barValue(
//                                               value: CGFloat(self.dataForLatestDate.count),
//                                               maxValue: Double( max( self.dataForLatestDate.count, self.dataForPreviousDate.count) ),
//                                               chartSize: 382
//                                           ),
//                                    chartSize: 382,
//                                    color: Color.green.opacity(0.5),
//                                    axis: .horizontal
//                                )
//
////                                Text(self.labelForDate(date: self.latestDate)).padding(5).font(.caption)
//                            }
//                        }
//                    }.frame(height: 80).background(Color.blue)
                    
//                    VStack(alignment: .leading, spacing: 5) {
//                        HStack(alignment: .firstTextBaseline) {
//                            Text("\(self.dataForPreviousDate.count)").font(.headline)
//                            Text("feeds").font(.subheadline)
//                        }
//
//                        GeometryReader { geometry in
//                            ZStack(alignment: .leading) {
//                                BarChartBarView(
//                                    width: 30,
//                                    value:  barValue(
//                                                value: CGFloat(self.dataForPreviousDate.count),
//                                                maxValue: Double( max( self.dataForLatestDate.count, self.dataForPreviousDate.count) ),
//                                                chartSize: geometry.size.width
//                                            ),
//                                    chartSize: geometry.size.width,
//                                    color: Color.green,
//                                    axis: .horizontal
//                                ).onTapGesture {
//                                    print(geometry)
//                                }
//
////                                Text(self.labelForDate(date: self.earliestDate)).padding(5).font(.caption)
//                            }
//                        }.frame(maxWidth: .infinity) //UIScreen.main.bounds.size.width
//                    }.frame(height: 80).background(Color.blue)
                }
                
                HStack(alignment: .bottom) {
                    GeometryReader { geometry in
                        ZStack {
                            HStack(alignment: .lastTextBaseline) {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(self.dailyOverviewIntro).font(.subheadline)
                                    Text("The longest feed is 18 minutes 13 seconds, which is 1 minute longer than the average from yesterday. ").font(.caption)
                                }
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
