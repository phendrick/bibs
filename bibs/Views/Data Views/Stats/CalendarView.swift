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
        GeometryReader {geometry in
            Pager(page: self.$calendarPage, data: calendarDates, id: \.self) {date in
                HeatmapView(
                    delegate: self.profile.parent,
                    itemSize: CGSize(width: ((geometry.frame(in: .local).size.width-30)/7), height: 30)
                )
                .background(Color.green)
            }.navigationBarTitle("Data")
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
