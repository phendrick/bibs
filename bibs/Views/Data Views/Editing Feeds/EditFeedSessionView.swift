//
//  EditFeedSessionView.swift
//  bibs
//
//  Created by Paul Hendrick on 19/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct EditFeedSessionView: View {
    @ObservedObject var feedSession: FeedSession
    var context: NSManagedObjectContext
    
    var body: some View {
        Form {
            Section(
                header: Text("Timers associated with this feed")
            ) {
                List {
                    ForEach(feedSession.feedsArray) {feed in
                        HStack {
                            NavigationLink(destination: EditFeedTimeView(feed: feed, context: self.context)) {
                                Text("\(feed.formattedElapsedTime())")
                                Spacer()
                                Text("\(feed.breastSide.description.0)").foregroundColor(.gray)
                            }
                        }
                    }.onDelete { (index) in
                        print("delete")
                    }
                }
            }
        }
        .navigationBarTitle(self.feedSession.wrappedCreatedAt.getFormattedDate(format: "EEEE, MMMM d"))
        .navigationBarItems(trailing: EditButton())
    }
}

struct EditFeedSessionView_Previews: PreviewProvider {
    static var previews: some View {
        let session = FeedSession()
        let feed    = Feed()
        
        feed.breastSide = .left
        feed.duration   = 1234
        session.addToFeeds(feed)
        
        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        return EditFeedSessionView(feedSession: session, context: context)
    }
}
