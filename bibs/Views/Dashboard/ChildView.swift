//
//  ChildView.swift
//  bibs
//
//  Created by Paul Hendrick on 04/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChildView: View {
    @EnvironmentObject var child: Child
    
    var body: some View {
        VStack {
            Text(child.wrappedName)
            
            VStack {
                ForEach(self.child.feedSessionsArray, id: \.self) {feedSession in
                    FeedSessionTimerView(feedSession: feedSession)
                        .background(feedSession.isActiveFeedSession ? Color.green : Color.red)
                }
            }
            .font(.system(.body, design: .monospaced))
            .background(Color.yellow)

            Spacer()
            
            Button(action: {
                do {
                    let _ = try self.child.startNewFeedSession()
                }catch {
                    fatalError()
                }
            }) {
                Text("Start new feed")
            }
        }
    }
}

struct ChildView_Previews: PreviewProvider {
    static var previews: some View {
        ChildView().environmentObject(Child())
    }
}
