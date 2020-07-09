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
    
    var body: some View {
        HStack {
            Image(systemName: self.feedSession.status == .paused ? "play" : "pause")
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
