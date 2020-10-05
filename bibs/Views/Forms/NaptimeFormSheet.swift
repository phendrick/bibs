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
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("nap_time".localized)
                Spacer()
                
                Button("save".localized) {
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
                        self.profile.objectWillChange.send()
                        self.naptimeFormVisible = false
                    }catch {
                        debugPrint("Error saving")
                    }
                }
            }
            .font(.headline)
            .padding()
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .clipped()
            .shadow(color: .gray, radius: 1, x: 0, y: 0)
            
            if profile.parent.activeChildrenArray.count > 1 {
                ChildrenFormList()
                    .padding()
                    .animation(nil)
            }
            
            Form {
                Section(
                    header: Text("from".localized)
                ) {
                    DatePicker(selection: self.$from, in: ...Date(), displayedComponents: .hourAndMinute) {
                        Text("time".localized)
                    }
                }
                Section {
                    GeometryReader {geometry in
                        HStack(alignment: .top, spacing: 0) {
                            Spacer()
                            
                            VStack(spacing: 0) {
                                Text("hours".localized).foregroundColor(Color(UIColor.label))
                                
                                Picker(selection: self.$hours, label: Text("Pick the hours")) {
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
                                Text("minutes".localized).foregroundColor(Color(UIColor.label))
                                
                                Picker("Pick the minutes", selection: self.$minutes) {
                                    ForEach(0..<60) {idx in
                                        Text(String(format: "%02i", idx)).tag(idx)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 100).labelsHidden()
                                .clipped()
                            }
                            
                            VStack(spacing: 0) {
                                Text("seconds".localized).foregroundColor(Color(UIColor.label))
                                
                                Picker("Pick the seconds", selection: self.$seconds) {
                                    ForEach(0..<60) {idx in
                                        Text(String(format: "%02i", idx)).tag(idx)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(width: 100).labelsHidden()
                                .clipped()
                            }
                            
                            Spacer()
                        }
                    }.frame(height: 240).padding(.top, 20)
                }
            }
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
