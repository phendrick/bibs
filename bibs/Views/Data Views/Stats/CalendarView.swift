//
//  CalendarView.swift
//  bibs
//
//  Created by Paul Hendrick on 12/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct CalendarView: View {
    @State var date: Date = Date()
    
    var body: some View {
        VStack {
            Form {
                Section(footer:
                    Button(action: {
                    }) {
                        HStack {
                            Text("Today")
                            Text("This Week")
                            Text("This Month")
                        }
                    }
                ) {
                    DatePicker(selection: self.$date) {
                        Text("Today")
                    }
                    
                    DatePicker(selection: self.$date) {
                        Text("")
                    }
                }
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
