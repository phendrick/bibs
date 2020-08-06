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
            Section(
                header: Text("Amend the hours, minutes and seconds for this feed")
            ){
                HStack(alignment: .lastTextBaseline) {
                    VStack {
                        Text("Hours").font(.subheadline)
                        TextField("Total Time \(self.feed.formattedElapsedTime())", text: self.$adjustedHours)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Text(":")
                    
                    VStack {
                        Text("Minutes").font(.subheadline)
                        TextField("Total Time \(self.feed.formattedElapsedTime())", text: self.$adjustedMinutes)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Text(":")
                    
                    VStack {
                        Text("Seconds").font(.subheadline)
                        TextField("Total Time \(self.feed.formattedElapsedTime())", text: self.$adjustedSeconds)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            
            Section(
                header: Text("Which side did \(self.feed.feedSession?.child?.wrappedName ?? "") feed from")
            ) {
                Picker(selection: self.$breastSide, label: Text("Side")) {
                    ForEach(Feed.BreastSide.allCases, id: \.self) {side in
                        Text("\(side.description.0)").tag(side.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
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
                print("Save")
                
//                if let _ = self.feed.setDurationFromStrings(hours: self.adjustedHours, minutes: self.adjustedMinutes, seconds: self.adjustedSeconds) {
//                    self.feed.breastSide = self.breastSide
//                }else {
//                    print("Error saving time")
//                }
//                
//                do {
//                    self.feed.objectWillChange.send()
//                    self.feed.feedSession?.objectWillChange.send()
//                    
//                    try self.context.save()
//                    
//                    // force the data in the "Manage" view to be reloaded since it's rendering a plain
//                    // set of CoreData objects, not observed objects on a publisher
//                    
//                    self.context.refreshAllObjects()
//                }catch {
//                    print("Error saving context")
//                }
//                
//                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
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
