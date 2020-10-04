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
    
    var body: some View {
        HStack(spacing: 20) {
            Button("Add Data") {
                guard var startDate = Calendar.current.date(byAdding: .month, value: -10, to: Date()), let child = self.profile.parent.childrenArray.first else {
                    print("no child or start date")
                    return
                }
                
                print("Starting at date \(startDate)")
                
                repeat {
                    for i in 2...Int.random(in: 3...5) {
                        let emotion = Emotion(context: self.moc)
                        emotion.createdAt = Date()
                        emotion.note = "the note for emotion \(i)"
                        emotion.status = Emotion.EmotionType.allCases.randomElement()!
                        
                        self.profile.parent.addToEmotions(emotion)
                    }
                    
                    for _ in 5...Int.random(in: 10...15) {
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
                }while(startDate.beginningOfDay < Date().endOfDay)
                
                print("Done at date \(startDate)")
                try? self.moc.save()
            }
            
            Button("Clear Data") {
                self.profile.parent.childrenArray.forEach {
                    $0.bottleFeedsArray.forEach { self.moc.delete($0) }
                    $0.nappyChangesArray.forEach { self.moc.delete($0) }
                    $0.feedSessionsArray.forEach { self.moc.delete($0) }
                    $0.napsArray.forEach { self.moc.delete($0) }
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

struct DevelopmentDataActionsView_Previews: PreviewProvider {
    static var previews: some View {
        DevelopmentDataActionsView(profile: ProfileObserver.shared)
    }
}
