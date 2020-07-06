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
    var cofeeding: Bool = false
    var cofeedingIndex: Int = 0
    
    @ObservedObject var feedSession: FeedSession
    
    func buttonIcon(state: FeedSession.FeedSessionStatus) -> String {
        state == .running ? "pause.fill" : "play.fill"
    }
    
    func breastSideIcon(state: Feed.BreastSide?) -> String {
        "circle.lefthalf.fill"
//        guard let side = self.feedSession.currentBreastSide else {
//            return "circle.lefthalf.fill"
//        }
//
//        return side == .left ? "circle.lefthalf.fill" : "circle.righthalf.fill"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("\(feedSession.formattedElapsedTime())")
                    .onTapGesture {
                        if self.feedSession.status == .paused {
                            self.feedSession.resume()
                        }else if self.feedSession.status == .running {
                            self.feedSession.pause()
                        }
                    }
                
                if cofeeding {
                    Text("\(self.feedSession.child?.wrappedName ?? "")")
                }
            }
        }
        .font(.custom("RobotoMono-Regular", size: 20))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FeedSessionView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let session = FeedSession(context: context)
        
        return FeedSessionView(feedSession: session).environment(\.managedObjectContext, context)
    }
}
