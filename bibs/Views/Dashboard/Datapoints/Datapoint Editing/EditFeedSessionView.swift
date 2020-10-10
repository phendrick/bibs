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
    @Environment(\.managedObjectContext) var context
    @ObservedObject var profile: ProfileObserver
    @ObservedObject var feedSession: FeedSession
    
    func removeRows(at offsets: IndexSet) {
        for index in offsets {
            let row = feedSession.feedsArray[index]
            self.context.delete(row)
        }
        
        //self.moc.refreshAllObjects()
        try? self.context.save()
        self.profile.objectWillChange.send()
    }
    
    var body: some View {
        Form {
            Section(
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
                    }.onDelete(perform: removeRows)
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
        
        return EditFeedSessionView(profile: ProfileObserver.shared, feedSession: session)
    }
}
