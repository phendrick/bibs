//
//  BottleFeedsDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct NaptimesDataView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    @State var dateFilter: DataViewDateFilter = .today
    @State var dateFilterStartDate: Date = Date().beginningOfMonth
    @State var dateFilterEndDate: Date = Date().endOfMonth
    @State var dateOptionsSheetVisible: Bool = false
    
    func statsForResults(results: [Nap]) -> String {
        guard results.count > 0 else {
            return ""
        }
        
        let duration = results.reduce(into: 0) { (result, nap) in
            result += nap.duration
        }
        
        let time = duration.toHoursMinutesSeconds
        return "\(results.count) \("nap".pluralize(count: results.count)) totalling \(time.0) hour \(time.1) minutes and \(time.2) seconds."
    }
    
    @ViewBuilder func headerView(results: [Nap]) -> some View {
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
            format: "child = %@ AND createdAt >= %@ AND createdAt <= %@", "state",
            child, startDate as NSDate, endDate as NSDate
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
            ) {(result: Nap, count: Int) in
                NavigationLink(destination: EditNapView(profile: self.profile, nap: result)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("\(result.duration.formattedHoursAndMinutes)")
                            Text("\(result.wrappedCreatedAt.getFormattedDate())").foregroundColor(.gray)
                        }.padding([.top, .bottom])
                    }
                }
            }
            
            Spacer()
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
        .navigationBarTitle(Text("nap_times".localized), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct BottleFeedsDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottleFeedsDataView()
//    }
//}
