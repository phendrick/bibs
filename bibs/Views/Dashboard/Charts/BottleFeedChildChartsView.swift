//
//  BottleFeedChildChartsView.swift
//  bibs
//
//  Created by Paul Hendrick on 01/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct BottleFeedChildChartsView: View {
    var child: Child
    @ObservedObject var profile: ProfileObserver
    
    func getLastTwoDaysDateRange() -> ClosedRange<Date> {
        let sorted = self.child.bottleFeedsArray.sorted { $0.wrappedCreatedAt > $1.wrappedCreatedAt }
        
        guard let latest = sorted.first?.wrappedCreatedAt else {
            return Date().beginningOfDay...Date().endOfDay
        }
        
        let earliestSession = sorted.first {
            $0.wrappedCreatedAt.beginningOfDay != latest.beginningOfDay
        }
        
        guard let earliest = earliestSession?.wrappedCreatedAt else {
            return latest.beginningOfDay...latest.endOfDay
        }
        
        return earliest.beginningOfDay...latest.endOfDay
    }
    
    @ViewBuilder var editButtonView: some View {
        NavigationLink(
            destination: BottleFeedsDataView(
                child: self.child,
                profile: self.profile
            ).environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        ) {
            Text("view_chart_data".localized)
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ChartStatsTodayView<BottleFeed>(
                    child: self.child,
                    chartData: TrackableChartData<BottleFeed>(
                        child: child,
                        range: self.getLastTwoDaysDateRange(),
                        includeAllDatesInRange: false
                    )
                )
                .background(Color(child.theme.0))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding()

                VStack {
                    ChartStatsWeeklyView<BottleFeed>(
                        child: self.child,
                        chartData: TrackableChartData<BottleFeed>(
                            child: self.child,
                            range: Date().beginningOfWeek.beginningOfDay...Date().beginningOfWeek.plusWeek,
                            includeAllDatesInRange: true
                        )
                    )
                    
                    BottleFeedWeeklyChartView(
                        dateRange: .week,
                        predicates: [NSPredicate(format: "child = %@", child)],
                        child: self.child
                    )
                    .frame(height: 260)
                    .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                }
                .background(Color(child.theme.0))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding()
                
                ChartStatsMonthlyView<BottleFeed>(
                    child: self.child,
                    chartData: TrackableChartData<BottleFeed>(
                        child: self.child,
                        range: Date().beginningOfMonth...Date().endOfMonth,
                        includeAllDatesInRange: true
                    )
                )
                .background(Color(child.theme.0))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding()
            }
            
        }
        .navigationBarTitle("bottle_feeds".localized)
        .navigationBarItems(trailing: editButtonView)
    }
}

//struct BottleFeedChildChartsView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottleFeedChildChartsView()
//    }
//}
