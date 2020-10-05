//
//  BottleFeedsDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct WeaningDataView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    @State var snackType: Snack.SnackType = .vegetables
    
    @State var dateFilter: DataViewDateFilter = .today
    @State var dateFilterStartDate: Date = Date().beginningOfMonth
    @State var dateFilterEndDate: Date = Date().endOfMonth
    @State var dateOptionsSheetVisible: Bool = false
    
    func statsForResults(results: [Snack]) -> String {
        guard results.count > 0 else {
            return ""
        }
        
        return "\(results.count) \("snack".pluralize(count: results.count))"
    }
    
    @ViewBuilder func headerView(results: [Snack]) -> some View {
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
            [self.snackType.rawValue], child, startDate as NSDate, endDate as NSDate
        )
    }
    
    var body: some View {
        VStack {
            Picker(selection: self.$snackType, label: Text("")) {
                ForEach(Snack.SnackType.allCases, id: \.self) {snack in
                    Text("\(snack.description)").tag(snack.rawValue)
                }
            }
            .padding()
            
            Spacer()
            
            DashboardDataView(
                profile: self.profile,
                predicate: filterPredicate(),
                sortDescriptors: [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ],
                headerView: headerView
            ) {(result: Snack, count: Int) in
                NavigationLink(destination: EditSnackView(profile: self.profile, snack: result)) {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("\(result.snackType.description) ") +
                            Text(result.note ?? "")
                        }
                        
                        Text("\(result.wrappedCreatedAt.getFormattedDate())").foregroundColor(.gray)
                    }.padding([.top, .bottom])
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
        .navigationBarTitle(Text("weaning".localized), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct BottleFeedsDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottleFeedsDataView()
//    }
//}
