//
//  ChildChartsView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FeedSessionChildChartsView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    func getLastTwoDaysDateRange() -> ClosedRange<Date> {
        let sorted = self.child.completedFeedSessionsArray.sorted { $0.wrappedCreatedAt > $1.wrappedCreatedAt }
        
        guard let latest = sorted.first?.wrappedCreatedAt else {
            return Date().beginningOfDay...Date().endOfDay
        }
        
        let earliestSession = sorted.first {
            print("\($0.wrappedCreatedAt.beginningOfDay) != \(latest.beginningOfDay) = \($0.wrappedCreatedAt.beginningOfDay != latest.beginningOfDay)")
            return $0.wrappedCreatedAt.beginningOfDay != latest.beginningOfDay
        }
        
        print("No earlier date")
        guard let earliest = earliestSession?.wrappedCreatedAt else {
            return latest.beginningOfDay...latest.endOfDay
        }
        
        return earliest.beginningOfDay...latest.endOfDay
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    FeedSessionStatsTodayView<FeedSession>(
                        child: self.child,
                        chartData: TrackableChartData<FeedSession>(
                            child: child,
                            range: self.getLastTwoDaysDateRange(),
                            includeAllDatesInRange: false,
                            allItems: self.child.completedFeedSessionsArray
                        )
                    )
                    
                    FeedSessionStatsWeeklyView<FeedSession>(
                        child: self.child,
                        chartData: TrackableChartData<FeedSession>(
                            child: self.child,
                            range: Date().beginningOfMonth...Date().endOfMonth,
                            includeAllDatesInRange: true,
                            allItems: self.child.completedFeedSessionsArray
                        )
                    )
                    
                    FeedSessionStatsMonthlyView<FeedSession>(
                        child: self.child,
                        chartData: TrackableChartData<FeedSession>(
                            child: self.child,
                            range: Date().beginningOfMonth...Date().endOfMonth,
                            includeAllDatesInRange: true,
                            allItems: self.child.completedFeedSessionsArray
                        )
                    )
                }
            }
        }
        .padding(.bottom, self.profile.trayHeight + 30)
        .background(Color(UIColor(named: "HighlightYellow")!))
        .navigationBarTitle("Charts")
    }
}

//struct ChildChartsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChildChartsView()
//    }
//}
