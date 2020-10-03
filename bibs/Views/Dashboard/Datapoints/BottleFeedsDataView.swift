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
    
    func statsForResults(results: [BottleFeed]) -> String {
        guard results.count > 0 else {
            return ""
        }
        
        let amount = results.reduce(into: 0) { (total, result) in
            total += result.amount
        }
        
        return "\(results.count) \("bottle".pluralize(count: results.count)) totalling \(amount)mls"
    }
    
    @ViewBuilder func headerView(results: [BottleFeed]) -> some View {
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
            [self.bottleFeedType.rawValue], child, startDate as NSDate, endDate as NSDate
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
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("\(result.amount)ml").fontWeight(.bold)  +
                                Text(" at ") +
                                Text("\(result.wrappedCreatedAt.getFormattedDate())").foregroundColor(.gray)
                            }
                        }.padding([.top, .bottom])
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
        .navigationBarTitle(Text("Bottle Feeds"), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct BottleFeedsDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottleFeedsDataView()
//    }
//}
