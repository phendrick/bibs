//
//  DevelopmentDataActionsView.swift
//  bibs
//
//  Created by Paul Hendrick on 03/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DevelopmentDataActionsView: View {
    @ObservedObject var profile: ProfileObserver
    @Environment(\.managedObjectContext) var moc
    @State var clearProfile: Bool = false
    
    var body: some View {
        VStack {
            Toggle(isOn: self.$clearProfile) {
                Text("Clear parent profile")
            }
            
            HStack(spacing: 20) {
                Button("Add Data") {
                    guard var startDate = Calendar.current.date(byAdding: .month, value: -10, to: Date()), let child = self.profile.parent.childrenArray.first else {
                        print("no child or start date")
                        return
                    }
                    
                    print("Starting at date \(startDate)")
                    let endDate = Calendar.current.date(bySettingHour: 15, minute: 30, second: 0, of: Date())!
                    
                    repeat {
                        for i in 2...Int.random(in: 3...5) {
                            let emotion = Emotion(context: self.moc)
                            emotion.createdAt = Date()
                            emotion.note = "the note for emotion \(i)"
                            emotion.status = Emotion.EmotionType.allCases.randomElement()!
                            
                            self.profile.parent.addToEmotions(emotion)
                        }
                        
                        let nap = Nap(context: self.moc)
                        nap.createdAt = startDate
                        nap.nappedAt = startDate
                        nap.setDurationFromValues(hours: 1, minutes: 15, seconds: 0)
                        
                        for _ in 3...Int.random(in: 6...8) {
                            let feedSession = FeedSession(context: self.moc)
                            let feed = Feed(context: self.moc)
                            feedSession.addToFeeds(feed)
                            feedSession.createdAt = startDate
                            feedSession.status = .complete
                            feed.createdAt = startDate
                            feed.duration = Int32.random(in: 1000...303030)
                            feed.breastSide = Feed.BreastSide.allCases.randomElement()!
                            child.addToFeedSessions(feedSession)
                            
                            let bottleFeed = BottleFeed(context: self.moc)
                            bottleFeed.createdAt = startDate
                            bottleFeed.amount = Int16.random(in: 10...40)
                            child.addToBottleFeeds(bottleFeed)
                            
                            let nappyChange = NappyChange(context: self.moc)
                            nappyChange.createdAt = startDate
                            nappyChange.status = NappyChange.NappyChangeType.allCases.randomElement()!
                            
                            if nappyChange.status == .dirty {
                                nappyChange.poopColor = NappyChange.NappyChangePoopColor.allCases.randomElement()!
                            }
                            
                            child.addToNappyChanges(nappyChange)
                        }
                        
                        startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
                    }while(startDate.beginningOfDay < endDate)
                    
                    print("Done at date \(startDate)")
                    try? self.moc.save()
                }
                
                Button("Clear Data") {
                    self.profile.parent.childrenArray.forEach {
                        $0.bottleFeedsArray.forEach { self.moc.delete($0) }
                        $0.nappyChangesArray.forEach { self.moc.delete($0) }
                        $0.feedSessionsArray.forEach { self.moc.delete($0) }
                        $0.napsArray.forEach { self.moc.delete($0) }
                        print("removed associated data")
                    }
                    
                    self.profile.parent.emotionsArray.forEach { self.moc.delete($0) }
                    
                    if self.clearProfile {
                        self.moc.delete(self.profile.parent)
                    }
                    
                    try? self.moc.save()
                }
                
                Button("Remove Children") {
                    self.profile.parent.childrenArray.forEach {self.moc.delete($0)}
                    try? self.moc.save()
                }
                
                Button("Add timer") {
                    guard let child = self.profile.parent.childrenArray.first else {
                        print("no child to add data to")
                        return
                    }
                    
                    if let activeSession = child.activeFeedSession {
                        print("Completing previous timer")
                        activeSession.complete()
                    }
                    
                    self.profile.objectWillChange.send()
                    try? child.startNewFeedSession()
                }
            }
            .padding()
        }
    }
}

struct DevelopmentDataActionsView_Previews: PreviewProvider {
    static var previews: some View {
        DevelopmentDataActionsView(profile: ProfileObserver.shared)
    }
}
