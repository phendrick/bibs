//
//  DashboardFeedTimerView.swift
//  bibs
//
//  Created by Paul Hendrick on 24/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardFeedTimerView: View {
    @ObservedObject var child: Child
    @Binding var layout: ActiveFeedsTrayView.ExpandedState
    var cofeeding: Bool
    
    var timerFontSize: CGFloat {
        if self.layout == .expanded {
            return 38
        }else {
            return self.cofeeding ? 28 : 32
        }
    }
    
    var breastSideLabel: String {
        guard let feedSession = self.child.activeFeedSession else {
            return ""
        }
        
        if self.layout == .expanded {
            return feedSession.currentBreastSide.description.0
        }else {
            //return (self.cofeeding) ? feedSession.currentBreastSide.description.1 : feedSession.currentBreastSide.description.0
            return feedSession.currentBreastSide.description.1
        }
    }
    
    var showBreastSideLabel: Bool {
        guard self.child.hasActiveFeedSession else {
            return false
        }
        
        return true
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // timer header - name and actions
            HStack(alignment: .firstTextBaseline) {
                Text("\(self.child.wrappedName)")
                    .font(.custom("RobotoMono-Regular", size: timerFontSize*0.5))
                    .layoutPriority(10)
                    .animation(nil)
                    .minimumScaleFactor(0.95)
                
                Spacer()
                
                if self.child.hasActiveFeedSession {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .frame(width: 40, alignment: .topTrailing)
                        .opacity(self.child.activeFeedSession?.status == .paused ? 1 : 0.25)
                        .onTapGesture {
                            guard self.child.activeFeedSession?.status == .paused else {
                                self.child.activeFeedSession?.pause()
                                
                                return
                            }

                            self.child.completeActiveFeedSession()
                            self.child.parent?.profileObserver?.objectWillChange.send()
                        }
                }
            }
            .frame(maxWidth: .infinity)
        
            // timer footer - time and details
            HStack(alignment: .lastTextBaseline) {
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                    Text("\(child.activeFeedSession?.formattedElapsedTime(include_hsec: false) ?? "00:00:00")")
                        .font(.custom("RobotoMono-Regular", size: timerFontSize * 0.6))
                    Text("\(child.activeFeedSession?.formattedElapsedTimeHsecs(includeRandomMsec: true) ?? ".00")")
                        .font(.custom("RobotoMono-Regular", size: timerFontSize * 0.5))
                        .opacity(0.5)
                }
                .layoutPriority(100)
                .opacity(child.hasActiveFeedSession ? 1 : 0.5)

                Spacer()
                
                if self.showBreastSideLabel {
                    HStack {
                        Text(breastSideLabel)
                            .onTapGesture {
                                guard !self.cofeeding else {
                                    return
                                }

                                self.child.activeFeedSession?.switchSide()
                            }
                            .font(.custom("RobotoMono-Regular", size: timerFontSize * 0.3))
                            .opacity(self.cofeeding ? 0.25 : 1)
                            .padding(.trailing, 2)
                    }
                }
            } // timer footer
        }
        .animation(nil)
        .padding(self.layout == .minimised ? 5 : 15)
        .frame(maxWidth: .infinity)
        .background(Color(self.child.theme.0))
        .foregroundColor(.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 0, x: 0, y: 10)
        .onTapGesture {
            guard let feedSession = self.child.activeFeedSession else {
                try? self.child.startNewFeedSession()
                return
            }
            
            if feedSession.status == .paused {
                feedSession.resume()
            }else if feedSession.status == .running {
                feedSession.pause()
            }
        }
    }
}
