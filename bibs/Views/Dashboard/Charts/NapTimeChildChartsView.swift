//
//  NapTimeChildChartsView.swift
//  bibs
//
//  Created by Paul Hendrick on 01/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct NapTimeChildChartsView: View {
    var child: Child
    @ObservedObject var profile: ProfileObserver
    
    func getLastTwoDaysDateRange() -> ClosedRange<Date> {
        let sorted = self.child.napsArray.sorted { $0.wrappedCreatedAt > $1.wrappedCreatedAt }
        
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
            destination: NaptimesDataView(
                child: self.child,
                profile: self.profile
            ).environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
        ) {
            Text("View Data".localized)
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ChartStatsTodayView<Nap>(
                    child: self.child,
                    chartData: TrackableChartData<Nap>(
                        child: child,
                        range: self.getLastTwoDaysDateRange(),
                        includeAllDatesInRange: false
                    )
                )
                .background(Color(child.theme.0))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding()

                ChartStatsWeeklyView<Nap>(
                    child: self.child,
                    chartData: TrackableChartData<Nap>(
                        child: self.child,
                        range: Date().lastSevenDays...Date().endOfDay,
                        includeAllDatesInRange: true
                    )
                )
                .background(Color(child.theme.0))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding()

                ChartStatsMonthlyView<Nap>(
                    child: self.child,
                    chartData: TrackableChartData<Nap>(
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
        .navigationBarTitle("Nap Times")
        .navigationBarItems(trailing: editButtonView)
    }
}

//struct NapTimeChildChartsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NapTimeChildChartsView()
//    }
//}
