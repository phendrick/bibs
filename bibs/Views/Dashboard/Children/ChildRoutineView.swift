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
    
    @State var showMorningNapForm: Bool = false
    @State var showAfternoonNapForm: Bool = false
    @State var showBedtimeForm: Bool = false
    
    @State var morningNaptimeRoutineStart: Date = Calendar.current.date(bySettingHour: 9, minute: 30, second: 0, of: Date())!
    @State var morningNaptimeRoutineEnd: Date = Calendar.current.date(bySettingHour: 11, minute: 0, second: 0, of: Date())!
    
    @State var afternoonNaptimeRoutineStart: Date = Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!
    @State var afternoonNaptimeRoutineEnd: Date = Calendar.current.date(bySettingHour: 16, minute: 30, second: 0, of: Date())!
    
    var body: some View {
        Form {
            Section(header: Text("sleep".localized)) {
                HStack {
                    Text("morning_nap".localized).fixedSize().frame(width: 100, alignment: .leading)
                    Spacer()
                    
                    NavigationLink(
                        destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                        isActive: self.$showMorningNapForm,
                        label: {
                            HStack {
                                Spacer()
                                Text("10am - 12pm") //.font(.system(.callout, design: .monospaced))
                            }
                        }
                    )
                }
                
                HStack {
                    Text("afternoon_nap".localized).fixedSize().frame(width: 100, alignment: .leading)
                    Spacer()
                    
                    NavigationLink(
                        destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                        isActive: self.$showAfternoonNapForm,
                        label: {
                            HStack {
                                Spacer()
                                Text("14am - 17pm")
                            }.font(.callout)
                        }
                    )
                }
                
                HStack {
                    Text("bedtimes".localized).fixedSize().frame(width: 100, alignment: .leading)
                    Spacer()
                    
                    NavigationLink(
                        destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
                        isActive: self.$showBedtimeForm,
                        label: {
                            HStack {
                                Spacer()
                                Text("10am - 12pm")
                            }
                        }
                    )
                }
            }
            
            Section(header: Text("cluster_feeds".localized)) {
                HStack {
                    Text("monitor_cluster_feeds".localized)
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(UIColor.systemGreen) )
                }
                
                Slider(value: self.$feedCountValue, in: 5...25, minimumValueLabel: Text("1"), maximumValueLabel: Text("25")) {
                }
            }
            
            Section(header: Text("feeds".localized)) {
                HStack {
                    Text("monitor_feed_length".localized)
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(UIColor.systemGreen) )
                }
                
                Slider(value: self.$feedCountValue, in: 1...60, minimumValueLabel: Text("1"), maximumValueLabel: Text("50")) {
                }
            }
        }.navigationBarTitle(Text("Routine"))
    }
}

struct ChildRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        ChildRoutineView()
    }
}
