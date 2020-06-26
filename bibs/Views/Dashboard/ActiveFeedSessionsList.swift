//
//  ActiveFeedSessions.swift
//  bibs
//
//  Created by Paul Hendrick on 09/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ActiveFeedSessionsList: View {
    @FetchRequest(
        entity: FeedSession.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "state IN %@", [
            FeedSession.FeedSessionStatus.running.rawValue, FeedSession.FeedSessionStatus.paused.rawValue
        ]),
        animation: .spring()) var activeFeedSessions: FetchedResults<FeedSession>
    
    var body: some View {
        ForEach(activeFeedSessions) {session in
            HStack {
                Text("\(session.status.rawValue) \(session.child?.wrappedName ?? "")")
                Button(action: {
                    try? session.finish()
                }) {
                    Text("Finish")
                }
            }
        }
    }
}

struct ActiveFeedSessions_Previews: PreviewProvider {
    static var previews: some View {
        ActiveFeedSessionsList()
    }
}
