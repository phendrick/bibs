//
//  The actions to affect a timer
//
//  FeedSessionTimerActions.swift
//  bibs
//
//  Created by Paul Hendrick on 08/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FeedSessionTimerActions: View {
    @ObservedObject var feedSession: FeedSession
    var expandedView = true
    
    var frameSize: CGFloat {
        expandedView ? 60 : 40
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            BreastSideView(feedSession: self.feedSession, color: .white, expandedView: expandedView)
                .frame(width: frameSize, height: frameSize/2)
                .onTapGesture {
                    self.feedSession.switchSide()
                }
            
            Spacer()
            
            Image(systemName: self.feedSession.status == .paused ? "play" : "pause")
            .frame(width: 30, height: 30)
            .onTapGesture {
                if self.feedSession.status == .paused {
                    self.feedSession.resume()
                }else if self.feedSession.status == .running {
                    self.feedSession.pause()
                }
            }
        }
    }
}

struct FeedSessionTimerActions_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let session = FeedSession(context: context)
        
        return FeedSessionTimerActions(feedSession: session).environment(\.managedObjectContext, context)
    }
}
