//
//  DashboardFeedTimerView.swift
//  bibs
//
//  Created by Paul Hendrick on 24/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardFeedTimerView: View {
    @ObservedObject var profile: ProfileObserver
    @ObservedObject var feedSession: FeedSession
    var color: Color
    
    @Binding var layout: ActiveFeedsTrayView.ExpandedState
    var cofeeding: Bool
    
    var body: some View {
        var timerFontSize: CGFloat {
            self.layout == .expanded ? 32 : 20
        }
        
        return VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    HStack(spacing: 5) {
                        Text("\(self.feedSession.child?.wrappedName ?? "")").font(.callout)
                        
                        if self.layout == .expanded || !self.cofeeding {
                            Text(self.feedSession.currentBreastSide.description.0)
                            .padding(5)
                            .frame(width: 100)
                            .onTapGesture {
                                guard !self.cofeeding else {
                                    return
                                }
                                print("Switching")
                                self.feedSession.switchSide()
                            }
                            .overlay(Capsule().stroke(Color.white, lineWidth: 1))
                            .font(.callout)
                        }
                    }
                    
                    Spacer()
                    
                    Button("Done") {
                        withAnimation {
                            guard self.feedSession.status == .paused else {
                                return
                            }
                            self.profile.objectWillChange.send()
                            self.feedSession.complete()
                        }
                    }
                    .font(.callout)
                    .padding(5)
                    .overlay(
                        Capsule()
                            .stroke(Color.white, lineWidth: 1)
                            .frame(width: 70)
                    ).opacity(self.feedSession.status == .running ? 0.5 : 1)
                }.animation(nil)
                
                Spacer()
                
                HStack(alignment: .center) {
                    Text("\(feedSession.formattedElapsedTime())")
                        .font(.custom("RobotoMono-Regular", size: timerFontSize))
                        .layoutPriority(10)
                    
                    Spacer()
                    
                    if self.layout == .expanded || !self.cofeeding {
                        Image(systemName: self.feedSession.status == .paused ? "play" : "pause")
                            .animation(nil)
                            .frame(width: 60, height: 60)
                    }
                }.animation(nil)
            }
        }
        .padding()
        .padding(.trailing, 5)
        .background(self.feedSession.child?.theme.0)
        .foregroundColor(.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 0, x: 0, y: 10)
        .frame(maxWidth: .infinity, maxHeight: self.layout == .expanded ? 120 : 120)
        .onTapGesture {
            print("Toggling...")
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

struct DashboardFeedTimerView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let session = FeedSession(context: context)
        let feed = Feed(context: context)
        feed.duration = 23423
        session.addToFeeds(feed)
        
        return Group {
            DashboardFeedTimerView(
                profile: ProfileObserver.shared,
                feedSession: session,
                color: .green,
                layout: .constant(ActiveFeedsTrayView.ExpandedState.minimal),
                cofeeding: true
            ).previewLayout(.fixed(width: 160, height: 280))

            DashboardFeedTimerView(
                profile: ProfileObserver.shared,
                feedSession: session,
                color: .green,
                layout: .constant(ActiveFeedsTrayView.ExpandedState.expanded),
                cofeeding: false
            ).previewLayout(.fixed(width: 420, height: 280))
        }
    }
}
