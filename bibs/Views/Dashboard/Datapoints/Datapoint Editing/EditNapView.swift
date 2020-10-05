//
//  EditNapView.swift
//  bibs
//
//  Created by Paul Hendrick on 09/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct EditNapView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var profile: ProfileObserver
    @ObservedObject var nap: Nap
    
    @State var from:Date = Date()
    @State var hours:Int = 0
    @State var minutes:Int = 0
    @State var seconds:Int = 0
    
    var body: some View {
        VStack {
            Form {
                Section(
                    header: Text("\(nap.child?.wrappedName ?? "") napped from")
                ) {
                    DatePicker(selection: self.$from, displayedComponents: .hourAndMinute) {
                        Text("Time")
                    }
                }
                Section {
                    GeometryReader {geometry in
                        HStack(alignment: .top, spacing: 0) {
                            VStack(spacing: 0) {
                                Text("Hours").font(.caption).foregroundColor(Color(UIColor.label))
                                
                                Picker(selection: self.$hours, label: Text("Test")) {
                                    Text("00").tag(0)
                                    Text("01").tag(1)
                                    Text("02").tag(2)
                                    Text("03").tag(3)
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: geometry.size.width/4)
                                .labelsHidden()
                                .clipped()
                            }
                            
                            VStack(spacing: 0) {
                                Text("Minutes").font(.caption).foregroundColor(Color(UIColor.label))
                                
                                Picker("test", selection: self.$minutes) {
                                    ForEach(0..<60) {idx in
                                        Text(String(format: "%02i", idx)).tag(idx)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 100).labelsHidden()
                                .clipped()
                            }
                            
                            VStack(spacing: 0) {
                                Text("Seconds").font(.caption).foregroundColor(Color(UIColor.label))
                                
                                Picker("test", selection: self.$seconds) {
                                    ForEach(0..<60) {idx in
                                        Text(String(format: "%02i", idx)).tag(idx)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 100).labelsHidden()
                                .clipped()
                            }
                        }
                    }.frame(height: 240).padding(.top, 20)
                }
            }
        }
        .onAppear(perform: {
            self.from = self.nap.nappedAt ?? Date()
            self.hours = self.nap.duration.toHoursMinutesSeconds.0
            self.minutes = self.nap.duration.toHoursMinutesSeconds.1
            self.seconds = self.nap.duration.toHoursMinutesSeconds.2
        })
        .navigationBarItems(trailing: Button("save".localized) {
            self.nap.nappedAt = self.from
            let _ = self.nap.setDurationFromValues(hours: self.hours, minutes: self.minutes, seconds: self.seconds)
            
            do {
                try self.context.save()
                self.profile.objectWillChange.send()
                self.presentationMode.wrappedValue.dismiss()
            }catch {
            }
        })
    }
}

struct EditNapView_Previews: PreviewProvider {
    static var previews: some View {
        let nap = Nap()
        
        return EditNapView(profile: ProfileObserver.shared, nap: nap)
    }
}
