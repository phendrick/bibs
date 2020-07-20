//
//  CalendarView.swift
//  bibs
//
//  Created by Paul Hendrick on 12/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct TimelineView: View {
    @EnvironmentObject var profile: ProfileObserver
    
    @State var date: Date = Date()
    @State var endDate: Date? = nil
    @State var datePickerVisible: Bool = false
    
    @State var selectedDateRange: ParentProfile.TrackableItemDateRange = .today
    
    fileprivate func viewForRow(row: Int) -> some View {
//        NappyChangeCalendarRowView()
        print("Getting item", row)
//        return FeedSessionCalendarRowView()
        return Text("K")
    }
    
    var body: some View {
        VStack {
            Form {
                Section(footer:
                    HStack {
                        Button(action: {
                            self.selectedDateRange = .today
                        }) {
                            HStack {
                                Text("Today")
                            }
                        }
                        Button(action: {
                            if self.profile.parent.weeklyDataSevenDays {
                                self.selectedDateRange = .weekFrom(Date().lastSevenDays)
                            }else {
                                if self.profile.parent.startOfWeekDay == 1 {
                                    self.selectedDateRange = .week
                                }else {
                                    self.selectedDateRange = .weekFromMonday
                                }
                            }
                        }) {
                            HStack {
                                Text("This Week")
                            }
                        }
                        Button(action: {
                            self.selectedDateRange = .month
                        }) {
                            HStack {
                                Text("This Month")
                            }
                        }
                        
                        Button(action: {
                            self.selectedDateRange = .all
                        }) {
                            HStack {
                                Text("Everything")
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                        }) {
                            HStack {
                                Text("Choose a date")
                                    .foregroundColor(Color(UIColor.systemOrange))
                            }
                        }
                    }
                ) {
                    HStack {
                        Text("Date")
                        Spacer()
                        
                        Text(self.selectedDateRange.detail)
                            .foregroundColor(Color(UIColor.systemGray))
                    }
                } // header form
                
                Section {
                    ForEach(0 ..< self.profile.parent.trackedItems(within: self.selectedDateRange).count, id: \.self ) { index in
                        Text("\(self.profile.parent.trackedItems(within: self.selectedDateRange)[index].title)")
                    }
                }
            }
        }
        .navigationBarTitle(self.selectedDateRange.description)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
