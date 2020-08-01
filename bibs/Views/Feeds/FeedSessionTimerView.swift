//
//  Renders a timer on the dashboard feeds tool
//
//  FeedSessionView.swift
//  bibs
//
//  Created by Paul Hendrick on 31/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import Foundation

struct FeedSessionTimerView: View {
    @ObservedObject var profile: ProfileObserver
    @ObservedObject var feedSession: FeedSession
    var expandedView = true
    
    var fontSize: CGFloat {
        expandedView ? 20 : 14
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(feedSession.formattedElapsedTime())")
                    .font(.custom("RobotoMono-Regular", size: fontSize))
                
                if !expandedView {
                    Text(self.feedSession.currentBreastSide.description.2)
                        .font(.custom("RobotoMono-Regular", size: fontSize))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedSessionView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let session = FeedSession(context: context)
        let feed = Feed()
        feed.duration = 23423
        session.addToFeeds(feed)
        
        return FeedSessionTimerView(profile: ProfileObserver.shared, feedSession: session).environment(\.managedObjectContext, context)
    }
}
