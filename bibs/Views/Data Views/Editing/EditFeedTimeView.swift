//
//  EditFeedTimeView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct EditFeedTimeView: View {
    let feedSession: FeedSession
    
    var body: some View {
        ForEach(feedSession.feedsArray) {feed in
            Text("\(feed.duration) - \(feed.breastSide.description)")
        }
    }
}

struct EditFeedTimeView_Previews: PreviewProvider {
    static var previews: some View {
        let session = FeedSession()
        let feed    = Feed()
        
        feed.breastSide = .left
        feed.duration   = 1234
        session.addToFeeds(feed)
        
        return EditFeedTimeView(feedSession: session)
    }
}
