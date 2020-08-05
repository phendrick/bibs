//
//  NaptimeFormSheet.swift
//  bibs
//
//  Created by Paul Hendrick on 27/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct NaptimeFormSheet: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    @Binding var naptimeFormVisible: Bool
    
    @State var from:Date = Date()
    @State var hours:Int = 0
    @State var minutes:Int = 0
    @State var seconds:Int = 0
    
    var childName: String {
        self.profile.parent.activeChild?.wrappedName ?? ""
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                }.padding([.top, .trailing], 15)
            }
            
            Text("Add a nap").font(.title)
            
            if profile.parent.activeChildrenArray.count > 1 {
                ChildrenFormList()
                    .padding()
                    .animation(nil)
            }
            
            Form {
                Section(
                    header: Text("\(childName) napped from")
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
            }.onAppear {
//                let elapstedTime = self.feed.calculatedElapsedTime
//
//                self.adjustedHours   = String(elapstedTime.hours)
//                self.adjustedMinutes = String(elapstedTime.minutes)
//                self.adjustedSeconds = String(elapstedTime.seconds)
//
//                self.breastSide      = self.feed.breastSide
            }
            
            VStack {
                Button("Save") {
                    guard let child = self.profile.parent.activeChild else {
                        debugPrint("No activeChild")
                        return
                    }
                    
                    let naptime = Nap(context: self.moc)
                    naptime.nappedAt = self.from
                    naptime.createdAt = Date()
                    let _ = naptime.setDurationFromValues(hours: self.hours, minutes: self.minutes, seconds: self.seconds)
                    child.addToNaps(naptime)
                     
                    do {
                        try self.moc.save()
                        
                        self.naptimeFormVisible = false
                    }catch {
                        debugPrint("Error saving")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height/8)
            .background(Color(UIColor.systemBackground))
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor.systemGray6))
    }
}

struct NaptimeFormSheet_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return NaptimeFormSheet(naptimeFormVisible: .constant(true))
            .environment(\.managedObjectContext, context)
            .environmentObject(ProfileObserver.shared)
    }
}
