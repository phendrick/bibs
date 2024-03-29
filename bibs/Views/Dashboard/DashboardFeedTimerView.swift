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
    var siblingCount: Int
    
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
    
    var iconName: String {
        guard let session = self.child.activeFeedSession else {
            return ""
        }
        
        return session.status == .running ? "pause.circle.fill" : "xmark.circle.fill"
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("\(self.child.wrappedName)")
                    .font(.system(.body, design: .monospaced))
                    .layoutPriority(10)
                    .animation(nil)
                    .minimumScaleFactor(0.95)
                
                Spacer()
                
                Image(systemName: iconName)
                    .foregroundColor(.white)
                    .frame(width: 40, alignment: .topTrailing)
                    .opacity(self.child.activeFeedSession == nil ? 0 : 1)
                    .onTapGesture {
                        guard self.child.activeFeedSession?.status == .paused else {
                            self.child.activeFeedSession?.pause()
                            
                            return
                        }

                        self.child.completeActiveFeedSession()
                        self.child.parent?.profileObserver?.objectWillChange.send()
                    }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, self.layout == .expanded ? 10 : 5)
            
            HStack(alignment: .lastTextBaseline) {
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                    Text("\(child.activeFeedSession?.formattedElapsedTime(include_hsec: false) ?? "00:00:00")")
                        .font(.system(.headline, design: .monospaced))
                    Text("\(child.activeFeedSession?.formattedElapsedTimeHsecs(includeRandomMsec: true) ?? ".00")")
                        .font(.system(.caption, design: .monospaced))
                        .opacity(0.5)
                }
                .layoutPriority(100)

                Spacer()
                
                HStack {
                    Text(breastSideLabel)
                        .onTapGesture {
                            guard !self.cofeeding else {
                                return
                            }

                            self.child.activeFeedSession?.switchSide()
                        }
                        //.font(.system(.caption, design: .monospaced))
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                }
            }
        }
        .padding(10)
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
