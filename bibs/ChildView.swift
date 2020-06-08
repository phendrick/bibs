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
            Text("OK")
                .onTapGesture {
                    print(self.child)
            }
            
            Text(child.wrappedName).onTapGesture {
                
            }

            Divider()

            VStack {
                ForEach(child.feedSessionsArray, id: \.self) {feedSession in
                    VStack {
                        VStack {
                            HStack {
                                Text("Session: \(feedSession.formattedElapsedTime)").onTapGesture {
                                    feedSession.toggle()
                                }
                                
                                Button(action: {
                                    feedSession.start()
                                }) {
                                    Text("Start")
                                }
                                
                                Button(action: {
                                    feedSession.switchSide()
                                }) {
                                    Text("Switch")
                                }
                            }
                        }
                        
                        VStack {
                            ForEach(feedSession.feedsArray, id: \.self) {feed in
                                HStack {
                                    Text("Feed \(feed.duration) - \(feed.formattedElapsedTime)")
                                        .onTapGesture {
                                            feedSession.resume()
                                    }
                                    
                                    Button(action: {
                                        try? feedSession.pause()
                                    }) {
                                        Text("X")
                                    }
                                }
                            }
                        }
                        .background(Color.orange)
                        
                        Divider()
                    }
                }
            }
            .font(.system(.body, design: .monospaced))
            .background(Color.yellow)

            Divider()

            Button(action: {
                self.child.startNewFeedSession()
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
