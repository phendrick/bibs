
//
//  FeedingOverviewView.swift
//  bibs
//
//  Created by Paul Hendrick on 21/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FeedingOverviewView: View {
    @ObservedObject var profile: ProfileObserver
    
    fileprivate func childrenFeedCount() -> Text {
        return
            Text("Milo and Tabitha have had ") +
            Text("21 feeds ").font(.headline) +
            Text("so far today.")
    }
    
    fileprivate func childrenFeedDetails() -> Text {
        return
            Text("Milo has had ") +
            Text("8 breastfeeds ").font(.headline) +
            Text("and ") +
            Text("5 bottle feeds ").font(.headline) +
            Text(", and Tabitha has had ") +
            Text("8 breastfeeds").font(.headline) +
            Text(".")
    }
    
    fileprivate func childrenNappyChangeDetails() -> Text {
        return
            Text("So far today you've changed ") +
            Text("12 nappies").font(.headline) +
            Text(", ") +
            Text("2 of Milo's poopy ones and 1 from Tabitha ") +
            Text("and 9 wet nappies. ") +
            Text("5 were Tabitha's and 4 from Milo") +
            Text(".")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            childrenFeedCount()
            childrenFeedDetails()
            childrenNappyChangeDetails()
        }
    }
}

struct FeedingOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        let profile = ProfileObserver.shared
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let parent = ParentProfile(context: context)
        profile.parent = parent
        
        let child = Child(context: context)
        parent.addToChildren(child)
        
        let session = FeedSession(context: context)
        var feed    = Feed(context: context)
        feed.breastSide = .left
        feed.duration = 234
        session.addToFeeds(feed)
        
        child.addToFeedSessions(session)
        
        feed = Feed(context: context)
        feed.breastSide = .right
        feed.duration = 234
        
        session.addToFeeds(feed)
        
        let child2 = Child(context: context)
        parent.addToChildren(child2)
        
        let bottle = BottleFeed(context: context)
        child2.addToBottleFeeds(bottle)
        
        return FeedingOverviewView(profile: profile)
    }
}
