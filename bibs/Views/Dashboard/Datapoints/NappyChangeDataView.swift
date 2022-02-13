//
//  NappyChangeDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct NappyChangesDataView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver

    @State var nappyChangeType: NappyChange.NappyChangeType = .wet

    @State var dateFilter: DataViewDateFilter = .today
    @State var dateFilterStartDate: Date = Date().beginningOfMonth
    @State var dateFilterEndDate: Date = Date().endOfMonth
    @State var dateOptionsSheetVisible: Bool = false
    
    @ViewBuilder func headerView(results: [NappyChange]) -> some View {
        VStack(alignment: .leading) {
//            Picker(selection: self.$nappyChangeType, label: Text("")) {
//                ForEach(NappyChange.NappyChangeType.allCases, id: \.self) {nappy in
//                    Text("\(nappy.description)").tag(nappy.rawValue)
//                }
//            }
//            .labelsHidden()
            
            DataViewDateFilterView(dateFilter: self.$dateFilter, dateOptionsSheetVisible: self.$dateOptionsSheetVisible)
        }
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
            format: "child = %@ AND createdAt >= %@ AND createdAt <= %@",
//            "state",
//            [self.nappyChangeType.rawValue],
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
            ) {(result: NappyChange, count: Int) in
                NavigationLink(destination: EditNappyChangeView(profile: self.profile, nappyChange: result)) {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("\(result.status.description)")
                            .font(.system(.headline))
                        
                        Text("\(result.detail.description)")
                            .font(.system(.subheadline))
                            .padding(2).padding([.leading, .trailing], 6)
                            .overlay(Capsule().stroke()).padding()
                        
                        Text("\(result.wrappedChangedAt.getFormattedDate())")
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
        .navigationBarTitle(Text("nappy_changes".localized), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct NappyChangeDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        NappyChangeDataView()
//    }
//}
