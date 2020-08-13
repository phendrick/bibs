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
    
    var timerHeight: CGFloat {
        var height: CGFloat = UIScreen.main.bounds.size.height / 12
        switch(self.layout) {
        case .expanded: height *= 2
        case .minimised: height *= 1.4
        }
        
        return height
    }
    
    var timerFontSize: CGFloat {
        if self.layout == .expanded {
            return 32
        }else {
            return self.cofeeding ? 20 :  22
        }
    }
    
    var breastSideLabel: String {
        if self.layout == .expanded  {
            return self.feedSession.currentBreastSide.description.0
        }else {
            return (self.cofeeding || self.profile.multipleWaiting) ? self.feedSession.currentBreastSide.description.1 : self.feedSession.currentBreastSide.description.0
        }
    }
    
    var breastSideLabelWidth: CGFloat {
        if self.layout == .expanded {
            return 100
        }else {
            return self.cofeeding ? 30 : 100
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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(self.feedSession.child?.wrappedName ?? "")")
                            .font(.system(size: timerFontSize * 0.75))
                            .layoutPriority(10)
                            .animation(nil)
                        
                        Spacer()
                        
                        Button(action: {
                            guard self.feedSession.status == .paused else {
                                return
                            }
                            
                            self.profile.objectWillChange.send()
                            self.feedSession.complete()
                            self.profile.setOffsetForLayout(layout: self.layout)
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                                .frame(width: 40, alignment: .topTrailing)
                        }
                        .opacity(self.feedSession.status == .paused ? 1 : 0.25)
                    }.frame(maxWidth: .infinity)
                    
                    Spacer()
                       
                    HStack {
                        HStack(alignment: .lastTextBaseline, spacing: 0) {
                            Text("\(feedSession.formattedElapsedTime(include_hsec: false))")
                                .font(.custom("RobotoMono-Regular", size: timerFontSize))
                                .layoutPriority(10)
                                .minimumScaleFactor(0.75)
                            Text("\(feedSession.formattedElapsedTimeHsecs())")
                                .font(.custom("RobotoMono-Regular", size: timerFontSize*0.75))
                                .opacity(0.5)
                                .minimumScaleFactor(0.75)
                        }
                        .animation(nil)
                        
                        Spacer()
                        
                        Text(breastSideLabel)
                        .padding(2)
                        .padding([.leading, .trailing], 10)
                        .onTapGesture {
                            guard !self.cofeeding else {
                                return
                            }
                            
                            self.feedSession.switchSide()
                        }
                        .overlay(Capsule().stroke(Color.white, lineWidth: 1).frame(maxWidth: breastSideLabelWidth))
                        .font(.caption)
                        .animation(nil)
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding([.top, .bottom])
        .padding([.leading, .trailing], 10)
        .frame(maxWidth: .infinity, maxHeight: timerHeight)
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
