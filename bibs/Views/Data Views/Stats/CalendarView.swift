//
//  CalendarView.swift
//  bibs
//
//  Created by Paul Hendrick on 12/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import SwiftUIPager

let calendarDates = [
//    Calendar.current.date(byAdding: .month, value: -4, to: Date()),
//    Calendar.current.date(byAdding: .month, value: -3, to: Date()),
//    Calendar.current.date(byAdding: .month, value: -2, to: Date()),
//    Calendar.current.date(byAdding: .month, value: -1, to: Date()),
//    Calendar.current.date(byAdding: .month, value: 0, to: Date()),
//    Calendar.current.date(byAdding: .month, value: 1, to: Date()),
    Calendar.current.date(byAdding: .month, value: 2, to: Date())
]

struct CalendarView: View {
    @EnvironmentObject var profile: ProfileObserver
    
    @State var calendarPage = 0
    
    var body: some View {
        Pager(page: self.$calendarPage, data: calendarDates, id: \.self) {date in
            HeatmapView(delegate: self.profile.parent)
                .frame(width: 350)
                .background(Color.green)
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
