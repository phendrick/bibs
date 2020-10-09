//
//  ChildChartsView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FeedSessionChildChartsView: View {
    var child: Child
    @ObservedObject var profile: ProfileObserver
    
    func getLastTwoDaysDateRange() -> ClosedRange<Date> {
        let sorted = self.child.completedFeedSessionsArray.sorted { $0.wrappedCreatedAt > $1.wrappedCreatedAt }
        
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
            destination: FeedTimersDataView(
                child: self.child,
                profile: self.profile
            ).environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        ) {
            Text("View Data".localized)
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ChartStatsTodayView<FeedSession>(
                    child: self.child,
                    chartData: TrackableChartData<FeedSession>(
                        child: child,
                        range: self.getLastTwoDaysDateRange(),
                        includeAllDatesInRange: false,
                        predicates: [NSPredicate(format: "state IN %@", [FeedSession.FeedSessionStatus.complete.rawValue])]
                    )
                )
                .background(Color(child.theme.0))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding()

                ChartStatsWeeklyView<FeedSession>(
                    child: self.child,
                    chartData: TrackableChartData<FeedSession>(
                        child: self.child,
                        range: Date().beginningOfWeek.beginningOfDay...Date().beginningOfWeek.plusWeek,
                        includeAllDatesInRange: true,
                        predicates: [NSPredicate(format: "state IN %@", [FeedSession.FeedSessionStatus.complete.rawValue])]
                    )
                )
                .background(Color(child.theme.0))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding()
                
                ChartStatsMonthlyView<FeedSession>(
                    child: self.child,
                    chartData: TrackableChartData<FeedSession>(
                        child: self.child,
                        range: Date().beginningOfMonth...Date().endOfMonth,
                        includeAllDatesInRange: true,
                        predicates: [NSPredicate(format: "state IN %@", [FeedSession.FeedSessionStatus.complete.rawValue])]
                    )
                )
                .background(Color(child.theme.0))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding()
            }
        }
        .navigationBarTitle("breastfeeds".localized)
        .navigationBarItems(trailing: editButtonView)
    }
}

//struct ChildChartsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChildChartsView()
//    }
//}
