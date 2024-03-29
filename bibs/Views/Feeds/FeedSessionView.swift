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
    @ObservedObject var feedSession: FeedSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("\(feedSession.child?.wrappedName ?? "")")
                Text("\(feedSession.formattedElapsedTime())")
                    .onTapGesture {
                        if self.feedSession.status == .paused {
                            self.feedSession.resume()
                        }else if self.feedSession.status == .running {
                            self.feedSession.pause()
                        }
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
        
        return FeedSessionTimerView(feedSession: session).environment(\.managedObjectContext, context)
    }
}
