//
//  FeedSessionView.swift
//  bibs
//
//  Created by Paul Hendrick on 31/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import Foundation

struct FeedSessionView: View {
    @EnvironmentObject var feedSession: FeedSession
    
    var body: some View {
        VStack {
            HStack {
                Text("Session: \(feedSession.formattedElapsedTime(include_hsec: false))").onTapGesture {
                    print("Session tapped: \(self.feedSession.status.rawValue)")
                    
                    if(self.feedSession.status == .running) {
                        self.feedSession.pause()
                    }else if(self.feedSession.status == .paused) {
                        self.feedSession.resume()
                    }
                }
                
                Text("\(feedSession.status.rawValue)")
                
                if feedSession.status == .paused {
                    Button(action: {
                        self.feedSession.resume()
                    }) {
                        Image(systemName: "play")
                    }
                }else if(feedSession.status == .running) {
                    Button(action: {
                        self.feedSession.pause()
                    }) {
                        Image(systemName: "pause")
                    }
                }
                
                if(feedSession.status != .complete) {
                    Button(action: {
                        self.feedSession.switchSide()
                    }) {
                        Image(systemName: "arrow.right.arrow.left")
                    }
                }
            }
            
            VStack {
                ForEach(feedSession.feedsArray, id: \.self) {feed in
                    HStack {
                        Text("\(feed.formattedElapsedTime)")
                    }
                }
            }
            .background(Color.orange)
        }
    }
}

struct FeedSessionView_Previews: PreviewProvider {
    static var previews: some View {
        FeedSessionView().environmentObject(FeedSession())
    }
}
