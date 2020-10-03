//
//  FeedTimersDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

enum DataViewDateFilter: CaseIterable {
    case today
    case week
    case month
    case date
    
    var description: String {
        switch(self) {
        case .today: return "Today"
        case .week: return "This Week"
        case .month: return "This Month"
        case .date: return "Date"
        }
    }
}

struct FeedTimersDataView: View {    
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    @State var feedSessionType: FeedSession.FeedSessionStatus = .complete
    @State var dateFilter: DataViewDateFilter = .today
    @State var dateFilterStartDate: Date = Date().beginningOfMonth
    @State var dateFilterEndDate: Date = Date().endOfMonth
    @State var dateOptionsSheetVisible: Bool = false
    
    func statsForResults(results: [FeedSession]) -> String {
        guard results.count > 0 else {
            return ""
        }
        
        let duration = results.reduce(into: 0) { (result, session) in
            result += session.duration
        }
        
        let time = duration.toHoursMinutesSeconds
        return "\(results.count) \("feed".pluralize(count: results.count)) totalling \(time.0) hour \(time.1) minutes and \(time.2) seconds."
    }
    
    func chartDataFrom(results: [FeedSession]) -> [Double] {
        return results.map {
            Double(Int($0.duration) / 100)
        }
    }
    
    @ViewBuilder func headerView(results: [FeedSession]) -> some View {
        VStack(alignment: .leading) {
            Text("\(statsForResults(results: results))")
            
            Divider()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 25) {
                    ForEach(DataViewDateFilter.allCases, id: \.self) {filter in
                        Button(filter.description) {
                            if filter != .date {
                                self.dateFilter = filter
                            }
                            
                            self.dateOptionsSheetVisible = filter == .date
                        }
                    }
                }
                .padding()
                .font(.callout)
            }
        }
    }
    
    func filterPredicate() -> NSPredicate {
        var startDate = Date().beginningOfDay
        var endDate = Date().endOfDay
        
        if self.dateFilter == .today {
            startDate = Date().beginningOfDay
            endDate = Date().endOfDay
        }else if self.dateFilter == .week {
            startDate = self.profile.parent.startOfWeekDay == 1 ? Date().beginningOfWeek : Date().beginningOfWeekMonday
            endDate = startDate.plusWeek
        }else if self.dateFilter == .month {
            startDate = Date().beginningOfMonth
            endDate   = startDate.endOfMonth
        }else {
            startDate = self.dateFilterStartDate
            endDate   = self.dateFilterEndDate
        }
        
        return NSPredicate(
            format: "%K IN %@ AND child = %@ AND createdAt >= %@ AND createdAt <= %@", "state",
            [self.feedSessionType.rawValue], child, startDate as NSDate, endDate as NSDate
        )
    }
    
    var body: some View {
        VStack {
            DashboardDataView(
                profile: self.profile,
                predicate: filterPredicate(),
                sortDescriptors: [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ],
                headerView: headerView
            ) {(result: FeedSession, count: Int) in
                NavigationLink(destination: EditFeedSessionView(profile: self.profile, feedSession: result)) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(result.formattedElapsedTime(include_hsec: false))")
                        }
                        
                        Text("\(result.wrappedCreatedAt.getFormattedDate())").foregroundColor(.gray)
                    }
                }
            }
        }
        .sheet(isPresented: $dateOptionsSheetVisible) {
            VStack(spacing: 50) {
                
                Section(header: Text("Date from")) {
                    DatePicker(selection: self.$dateFilterStartDate, in: ...Date(), displayedComponents: .date) {
                        Text("")
                    }.labelsHidden()
                }
                
                Section(header: Text("Date to")) {
                    DatePicker(selection: self.$dateFilterEndDate, in: ...Date(), displayedComponents: .date) {
                        Text("")
                    }.labelsHidden()
                }
                
                Button("Done") {
                    self.dateOptionsSheetVisible = false
                }
                
            }
            .onAppear(perform: {
                print(self.dateFilterStartDate)
            })
            .onDisappear {
                self.dateFilter = .date
            }
        }
        .navigationBarTitle(Text("Breastfeeds".localized), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}
//
//struct FeedTimersDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedTimersDataView()
//    }
//}
