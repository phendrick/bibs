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
        case .today: return "today".localized
        case .week:  return "this_week".localized
        case .month: return "this_month".localized
        case .date:  return "date".localized
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
    
    @ViewBuilder func headerView(results: [FeedSession]) -> some View {
        DataViewDateFilterView(dateFilter: self.$dateFilter, dateOptionsSheetVisible: self.$dateOptionsSheetVisible)
    }
    
    func filterPredicate() -> NSPredicate {
        var startDate = Date().beginningOfDay
        var endDate = Date().endOfDay
        
        if self.dateFilter == .today {
            startDate = Date().beginningOfDay
            endDate = Date().endOfDay
        }else if self.dateFilter == .week {
            startDate = Date().beginningOfWeek.beginningOfDay
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
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(result.formattedElapsedTime(include_hsec: false))")
                            .font(.system(.headline, design: .monospaced))
                        
                        Text("\(result.wrappedCreatedAt.getFormattedDate())")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }.padding([.top, .bottom])
                }
            }
        }
        .sheet(isPresented: $dateOptionsSheetVisible) {
            VStack(spacing: 50) {
                
                Section(header: Text("date_from".localized)) {
                    DatePicker(selection: self.$dateFilterStartDate, in: ...Date(), displayedComponents: .date) {
                        Text("")
                    }.labelsHidden()
                }
                
                Section(header: Text("date_to".localized)) {
                    DatePicker(selection: self.$dateFilterEndDate, in: ...Date(), displayedComponents: .date) {
                        Text("")
                    }.labelsHidden()
                }
                
                Button("done".localized) {
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
        .navigationBarTitle(Text("breastfeeds".localized), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct FeedTimersDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedTimersDataView()
//    }
//}
