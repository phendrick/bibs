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
    
    func statsForResults(results: [NappyChange]) -> String {
        guard results.count > 0 else {
            return ""
        }
        
        return "\(results.count) \("nappy change".pluralize(count: results.count))"
    }
    
    @ViewBuilder func headerView(results: [NappyChange]) -> some View {
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
            [self.nappyChangeType.rawValue], child, startDate as NSDate, endDate as NSDate
        )
    }
    
    var body: some View {
        VStack {
            Picker(selection: self.$nappyChangeType, label: Text("")) {
                ForEach(NappyChange.NappyChangeType.allCases, id: \.self) {nappy in
                    Text("\(nappy.description)").tag(nappy.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            DashboardDataView(
                profile: self.profile,
                predicate: filterPredicate(),
                sortDescriptors: [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ],
                headerView: headerView
            ) {(result: NappyChange, count: Int) in
                NavigationLink(destination: EditNappyChangeView(profile: self.profile, nappyChange: result)) {
                    VStack {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(spacing: 0) {
                                Text("\(result.status.description)")
                                Text("\(result.detail.description)")
                                    .font(.caption)
                                    .padding(2)
                                    .padding([.leading, .trailing], 6)
                                    .overlay(
                                        Capsule().stroke()
                                    ).padding()
                            }
                            
                            Text("\(result.wrappedCreatedAt.getFormattedDate())")
                                .foregroundColor(.gray)
                        }.padding()
                    }
                }
            }
            
            Spacer()
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
        .navigationBarTitle(Text("Nappy Changes"), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct NappyChangeDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        NappyChangeDataView()
//    }
//}
