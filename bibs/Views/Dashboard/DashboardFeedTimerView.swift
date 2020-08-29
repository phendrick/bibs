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
    
    var timerFontSize: CGFloat {
        if self.layout == .expanded {
            return 30
        }else {
            return self.cofeeding ? 26 : 28
        }
    }
    
    var brestSideLabelFontSize: CGFloat {
        if self.layout == .expanded {
            return 30
        }else {
            return self.cofeeding ? 26 : 28
        }
    }
    
    var breastSideLabel: String {
        if self.layout == .expanded  {
            return self.feedSession.currentBreastSide.description.0
        }else {
            return (self.cofeeding || self.profile.multipleWaiting) ? self.feedSession.currentBreastSide.description.1 : self.feedSession.currentBreastSide.description.0
        }
    }
    
    var breastSideLabelPadding: CGFloat {
        if self.layout == .minimised && self.cofeeding {
            return 10
        }else {
            return 0
        }
    }
    
    var includeHsec: Bool {
        self.layout != .minimised || !self.cofeeding
    }
    
    var showBreastSideLabel: Bool {
        return self.layout == .expanded || (!self.cofeeding && self.profile.parent.childrenWithoutCurrentFeedSessions.count < 2)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 10) {
                    // timer header - name and actions
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(self.feedSession.child?.wrappedName ?? "")")
                            .font(.system(size: timerFontSize * 0.65))
                            .layoutPriority(10)
                            .animation(nil)
                        
                        Spacer()
                        
                        Button(action: {
                            guard self.feedSession.status == .paused else {
                                return
                            }
                            
                            self.profile.objectWillChange.send()
                            self.feedSession.complete()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                                .frame(width: 40, alignment: .topTrailing)
                        }
                        .opacity(self.feedSession.status == .paused ? 1 : 0.25)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // timer footer - time and details
                    HStack(alignment: .lastTextBaseline) {
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            Text("\(feedSession.formattedElapsedTime(include_hsec: false))")
                                .font(.custom("RobotoMono-Regular", size: timerFontSize*0.80))
                                .layoutPriority(10)
                                .minimumScaleFactor(0.75)
                            Text("\(feedSession.formattedElapsedTimeHsecs())")
                                .font(.custom("RobotoMono-Regular", size: timerFontSize*0.6))
                                .opacity(0.5)
                        }

                        Spacer()

                        if self.showBreastSideLabel {
                            Text(breastSideLabel)
                            .onTapGesture {
                                guard !self.cofeeding else {
                                    return
                                }

                                self.feedSession.switchSide()
                            }
                            .padding([.leading, .trailing], 10).padding([.top, .bottom], 5)
                            .overlay(Capsule().stroke(Color.white, lineWidth: 1))
                            .font(.subheadline)
                            .animation(nil)
                        }
                    }
                    // timer footer
                }
            }
        }
        .animation(nil)
        .padding()
        .frame(maxWidth: .infinity)
        .background(self.feedSession.child?.theme.0)
        .foregroundColor(.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 0, x: 0, y: 10)
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
                layout: .constant(ActiveFeedsTrayView.ExpandedState.minimised),
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
