//
//  NappyChangeChildChartsView.swift
//  bibs
//
//  Created by Paul Hendrick on 01/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct NappyChangeChildChartsView: View {
    var child: Child
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
    
    @ViewBuilder var editButtonView: some View {
        NavigationLink(
            destination: NappyChangesDataView(
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
                NappyChangeDailyChartView(
                    dateRange: .today,
                    predicates: [NSPredicate(format: "child = %@", child)],
                    child: self.child
                )
                .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                .background(Color(child.theme.0))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding()

                NappyChangeWeeklyChartView(
                    range: .week,
                    predicates: [NSPredicate(format: "child = %@", child)],
                    child: self.child
                )
                .environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
                .background(Color(child.theme.0))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding()
                
                Spacer()
            }
        }
        .navigationBarTitle("nappy_changes".localized)
        .navigationBarItems(trailing: editButtonView)
    }
}

//struct NappyChangeChildChartsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NappyChangeChildChartsView()
//    }
//}
