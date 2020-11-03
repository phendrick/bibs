//
//  ChildRoutineView.swift
//  bibs
//
//  Created by Paul Hendrick on 31/10/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChildRoutineView: View {
    @State var monitorWakups: Bool = false
    @State var feedCountValue: Float = 10
    
    @State var sleepRoutineStart: Date = Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date())!
    @State var sleepRoutineEnd: Date = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date())!
    
    @State var morningNaptimeRoutineStart: Date = Calendar.current.date(bySettingHour: 9, minute: 30, second: 0, of: Date())!
    @State var morningNaptimeRoutineEnd: Date = Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!
    
    @State var afternoonNaptimeRoutineStart: Date = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!
    @State var afternoonNaptimeRoutineEnd: Date = Calendar.current.date(bySettingHour: 16, minute: 30, second: 0, of: Date())!
    
    var body: some View {
        Form {
            Section(header: Text("sleep".localized)) {
                HStack {
                    Text("Bedtime").fixedSize().frame(width: 100, alignment: .leading)
                    Spacer()
                    
                    DatePicker("", selection: self.$sleepRoutineStart, displayedComponents: .hourAndMinute)
                    DatePicker("", selection: self.$sleepRoutineEnd, displayedComponents: .hourAndMinute)
                }
                
                HStack {
                    Text("Morning Nap").fixedSize().frame(width: 100, alignment: .leading)
                    Spacer()
                    
                    DatePicker("", selection: self.$morningNaptimeRoutineStart, displayedComponents: .hourAndMinute)
                    DatePicker("", selection: self.$morningNaptimeRoutineEnd, displayedComponents: .hourAndMinute)
                }
                
                HStack {
                    Text("Afternoon Nap").fixedSize().frame(width: 100, alignment: .leading)
                    Spacer()
                    
                    DatePicker("", selection: self.$afternoonNaptimeRoutineStart, displayedComponents: .hourAndMinute)
                    DatePicker("", selection: self.$afternoonNaptimeRoutineEnd, displayedComponents: .hourAndMinute)
                }
                
                HStack {
                    Text("monitor_wakups")
                    Spacer()
                    Text("✅")
                }
            }
            
            Section(header: Text("feeds".localized)) {
                Slider(value: self.$feedCountValue, in: 5...25, minimumValueLabel: Text("1"), maximumValueLabel: Text("25")) {
                    
                }
                
                HStack {
                    Text("monitor_cluster_feeds")
                    Spacer()
                    Text("✅")
                }
            }
            
            Section(header: Text("feeds".localized)) {
                HStack {
                    Text("monitor_feed_length")
                    Spacer()
                    Text("✅")
                }
                
                Slider(value: self.$feedCountValue, in: 1...50, minimumValueLabel: Text("1"), maximumValueLabel: Text("50")) {
                }
            }
        }
    }
}

struct ChildRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        ChildRoutineView()
    }
}
