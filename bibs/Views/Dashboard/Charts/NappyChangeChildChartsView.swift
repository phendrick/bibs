//
//  NappyChangeChildChartsView.swift
//  bibs
//
//  Created by Paul Hendrick on 01/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct NappyChangeChildChartsView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    func getLastTwoDaysDateRange() -> ClosedRange<Date> {
        let sorted = self.child.nappyChangesArray.sorted { $0.wrappedCreatedAt > $1.wrappedCreatedAt }
        
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
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    CountStatesChartView<NappyChange, NappyChange.NappyChangeType>(
                        range: .today,
                        predicates: [NSPredicate(format: "child = %@", child)]
                    )

                    CountStatesChartView<NappyChange, NappyChange.NappyChangeType>(
                        range: .week,
                        predicates: [NSPredicate(format: "child = %@", child)]
                    )
                    
                    CountStatesChartView<NappyChange, NappyChange.NappyChangeType>(
                        range: .dateRange(Date().beginningOfMonth...Date().endOfMonth),
                        predicates: [NSPredicate(format: "child = %@", child)]
                    )
                }
            }
        }
        .padding(.bottom, self.profile.trayHeight + 30)
        .background(child.theme.0)
        .navigationBarTitle("Charts")
    }
}

//struct NappyChangeChildChartsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NappyChangeChildChartsView()
//    }
//}
