//
//  EditFeedTimeView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct EditFeedTimeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var feed: Feed
    var context: NSManagedObjectContext
    
    @State var adjustedHours:String = ""
    @State var adjustedMinutes:String = ""
    @State var adjustedSeconds:String = ""
    @State var breastSide:Feed.BreastSide = .left
    
    var body: some View {
        Form {
            Section {
                HStack(alignment: .lastTextBaseline) {
                    VStack {
                        Text("hours".localized).font(.subheadline)
                        TextField("\(self.feed.formattedElapsedTime())", text: self.$adjustedHours)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Text(":")
                    
                    VStack {
                        Text("minutes".localized).font(.subheadline)
                        TextField("\(self.feed.formattedElapsedTime())", text: self.$adjustedMinutes)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Text(":")
                    
                    VStack {
                        Text("seconds".localized).font(.subheadline)
                        TextField("\(self.feed.formattedElapsedTime())", text: self.$adjustedSeconds)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            
            Section {
                Picker(selection: self.$breastSide, label: Text("")) {
                    ForEach(Feed.BreastSide.allCases, id: \.self) {side in
                        Text("\(side.description.0)").tag(side.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }.onAppear {
            let elapstedTime = self.feed.calculatedElapsedTime
            
            self.adjustedHours   = String(elapstedTime.hours)
            self.adjustedMinutes = String(elapstedTime.minutes)
            self.adjustedSeconds = String(elapstedTime.seconds)
            
            self.breastSide      = self.feed.breastSide
        }
        .navigationBarTitle("\(self.feed.feedSession?.child?.wrappedName ?? "")'s feed")
        .navigationBarItems(
            trailing: Button(action: {
                let _ = self.feed.setDurationFromValues(
                    hours: Int(self.adjustedHours) ?? 0,
                    minutes: Int(self.adjustedMinutes) ?? 0,
                    seconds: Int(self.adjustedSeconds) ?? 0
                )
                
                if self.feed.breastSide != self.breastSide {
                    for feed in self.feed.feedSession!.feedsArray {
                        feed.breastSide = feed.breastSide.switched
                    }
                }
                
                do {
                    self.feed.objectWillChange.send()
                    self.context.refreshAllObjects()
                    try self.context.save()
                    self.presentationMode.wrappedValue.dismiss()
                }catch {
                    fatalError("Couldn't save")
                }
            }) {
                Text("save".localized)
            }
        )
    }
}

struct EditFeedTimeView_Previews: PreviewProvider {
    static var previews: some View {
        let session = FeedSession()
        let feed    = Feed()
        
        feed.breastSide = .left
        feed.duration   = 1234
        session.addToFeeds(feed)
        
        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        return EditFeedTimeView(feed: feed, context: context)
    }
}
