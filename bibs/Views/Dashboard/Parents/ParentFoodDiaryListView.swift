//
//  ParentFoodDiaryListView.swift
//  bibs
//
//  Created by Paul Hendrick on 08/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ParentFoodDiaryListView: View {
    @ObservedObject var profile: ProfileObserver
    
    @State var foodType: FoodDiaryEntry.FoodType = .vegetables
    
    @State var dateFilter: DataViewDateFilter = .today
    @State var dateFilterStartDate: Date = Date().beginningOfMonth
    @State var dateFilterEndDate: Date = Date().endOfMonth
    @State var dateOptionsSheetVisible: Bool = false
    
    func statsForResults(results: [FoodDiaryEntry]) -> String {
        guard results.count > 0 else {
            return ""
        }
        
        return "\(results.count) \("snack".pluralize(count: results.count))"
    }
    
    @ViewBuilder func headerView(results: [FoodDiaryEntry]) -> some View {
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
            format: "createdAt >= %@ AND createdAt <= %@",
            startDate as NSDate, endDate as NSDate
        )
    }
    
    var body: some View {
        VStack {
            VStack {
                DashboardDataView(
                    profile: self.profile,
                    predicate: filterPredicate(),
                    sortDescriptors: [
                        NSSortDescriptor(key: "createdAt", ascending: false)
                    ],
                    headerView: headerView
                ) {(result: FoodDiaryEntry, count: Int) in
                    HStack {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("\(result.foodType.emoji)")
                                Text("\(result.foodType.description)").fontWeight(.bold)
                            }
                            
                            HStack {
                                Text("\(result.wrappedCreatedAt.getFormattedDate())").foregroundColor(.gray)
                            }
                        }.padding([.top, .bottom])
                    }
                }
            }
        }
        .sheet(isPresented: $dateOptionsSheetVisible) {
            VStack {
                Form {
                    Section(header: Text("date_from".localized)) {
                        DatePicker(selection: self.$dateFilterStartDate, displayedComponents: .date) {
                            Text("")
                        }.labelsHidden()
                    }
                    
                    Section(header: Text("date_to".localized)) {
                        DatePicker(selection: self.$dateFilterEndDate, displayedComponents: .date) {
                            Text("")
                        }.labelsHidden()
                    }
                }
                
                Spacer()
                
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
        .navigationBarTitle("food_diary".localized)
    }
}

struct ParentFoodDiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        ParentFoodDiaryListView(profile: ProfileObserver.shared)
    }
}
