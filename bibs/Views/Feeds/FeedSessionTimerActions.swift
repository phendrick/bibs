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
    @ObservedObject var profile: ProfileObserver
    @ObservedObject var feedSession: FeedSession
    var expandedView = true
    
    var frameSize: CGFloat {
        expandedView ? 60 : 40
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            if self.feedSession.status == .paused || self.feedSession.status == .running {
                BreastSideView(feedSession: self.feedSession, color: .white, expandedView: expandedView)
                    .frame(width: frameSize, height: frameSize/2)
                    .onTapGesture {
                        self.feedSession.switchSide()
                    }
            }
            
            if self.feedSession.status == .paused {
                Text("Complete").animation(.spring()).onTapGesture {
                    withAnimation {
                        self.profile.objectWillChange.send()
                        self.feedSession.complete()
                    }
                }
            }
            
            Spacer()
            
            if self.feedSession.status == .paused || self.feedSession.status == .running {
                Image(systemName: self.feedSession.status == .paused ? "play" : "pause")
                .frame(width: 30, height: 30)
                .onTapGesture {
                    if self.feedSession.status == .paused {
                        withAnimation {
                            self.feedSession.resume()
                        }
                    }else if self.feedSession.status == .running {
                        withAnimation {
                            self.feedSession.pause()
                        }
                    }
                }
            }
        }
    }
}

struct FeedSessionTimerActions_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let session = FeedSession(context: context)
        
        return FeedSessionTimerActions(profile: ProfileObserver.shared, feedSession: session).environment(\.managedObjectContext, context)
    }
}
