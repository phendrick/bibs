//
//  ManualFeedTimerEntryFormSheet.swift
//  bibs
//
//  Created by Paul Hendrick on 27/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ManualFeedTimerEntryFormSheet: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    @Binding var feedTimerFormVisible: Bool
    
    @State var adjustedHours:Int = 0
    @State var adjustedMinutes:Int = 0
    @State var adjustedSeconds:Int = 0
    @State var from: Date = Date()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                }.padding([.top, .trailing], 15)
            }
            
            Text("Add a feed").font(.title)
            
            if profile.parent.activeChildrenArray.count > 1 {
                ChildrenFormList()
                    .padding()
                    .animation(nil)
            }
            
            Form {
                Section(
                    header: Text("\(self.profile.parent.activeChild?.wrappedName ?? "Baby") fed from")
                ) {
                    DatePicker(selection: self.$from) {
                        Text("Time")
                    }
                }
                
                Section(
                    header: Text("For")
                ){
                    GeometryReader {geometry in
                        HStack(alignment: .top, spacing: 0) {
                            VStack(spacing: 0) {
                                Text("Hours").font(.caption).foregroundColor(Color(UIColor.label))
                                
                                Picker(selection: self.$adjustedHours, label: Text("Test")) {
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
                                
                                Picker("test", selection: self.$adjustedMinutes) {
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
                                
                                Picker("test", selection: self.$adjustedSeconds) {
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
                    
                    let feedSession = FeedSession(context: self.moc)
                    let feed = Feed(context: self.moc)
                    feed.breastSide = .left
                    feed.createdAt = self.from
                    
                    feedSession.addToFeeds(feed)
                    feedSession.createdAt = Date()
                    feedSession.status = .complete
                    
                    let _ = feed.setDurationFromValues(
                        hours: self.adjustedHours,
                        minutes: self.adjustedMinutes,
                        seconds: self.adjustedSeconds
                    )
                    
                    child.addToFeedSessions(feedSession)
                    
                    do {
                        try self.moc.save()
                        
                        self.feedTimerFormVisible = false
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

struct ManualFeedTimerEntryFormSheet_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let feedSession = FeedSession()
        let feed = Feed()
        feedSession.addToFeeds(feed)
        
        return ManualFeedTimerEntryFormSheet(feedTimerFormVisible: .constant(true))
            .environment(\.managedObjectContext, context)
            .environmentObject(ProfileObserver.shared)
    }
}