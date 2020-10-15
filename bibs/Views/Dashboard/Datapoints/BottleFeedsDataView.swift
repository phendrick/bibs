//
//  BottleFeedsDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct BottleFeedsDataView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    @Environment(\.managedObjectContext) var moc
    
    @State var dateFilter: DataViewDateFilter = .today
    @State var dateFilterStartDate: Date = Date().beginningOfMonth
    @State var dateFilterEndDate: Date = Date().endOfMonth
    @State var dateOptionsSheetVisible: Bool = false
    
    @State var bottleFeedType: BottleFeed.BottleFeedType = .expressedMilk
    
    @ViewBuilder func headerView(results: [BottleFeed]) -> some View {
        VStack(alignment: .leading) {
            DataViewDateFilterView(dateFilter: self.$dateFilter, dateOptionsSheetVisible: self.$dateOptionsSheetVisible)
        }
    }
    
    @ViewBuilder func filterView() -> some View {
        Picker(selection: self.$bottleFeedType, label: Text("")) {
            ForEach(BottleFeed.BottleFeedType.allCases, id: \.self) {storage in
                Text("\(storage.description)").tag(storage.rawValue)
            }
        }
        .labelsHidden()
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
            format: "%K IN %@ AND child = %@ AND createdAt >= %@ AND createdAt <= %@",
            "state",
            [self.bottleFeedType.rawValue],
            child, startDate as NSDate, endDate as NSDate
        )
    }
    
    var body: some View {
        VStack {
            Picker(selection: self.$bottleFeedType, label: Text("")) {
                ForEach(BottleFeed.BottleFeedType.allCases, id: \.self) {storage in
                    Text("\(storage.description)").tag(storage.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .padding()
            
            DashboardDataView(
                profile: self.profile,
                predicate: filterPredicate(),
                sortDescriptors: [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ],
                headerView: headerView
            ) {(result: BottleFeed, count: Int) in
                NavigationLink(destination: EditBottleFeedView(profile: self.profile, bottleFeed: result)) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(result.amount)ml")
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
        .navigationBarTitle(Text("bottle_feeds".localized), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct BottleFeedsDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottleFeedsDataView()
//    }
//}
