//
//  BreastSideView.swift
//  bibs
//
//  Created by Paul Hendrick on 21/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct BreastSideView: View {
    @ObservedObject var feedSession: FeedSession
    var color: Color
    var expandedView = true
    
    var leftOffset: CGFloat {
        let value: CGFloat = expandedView ? 10 : 0
        return feedSession.currentBreastSide == .left ? 0 : value
    }
    
    var rightOffset: CGFloat {
        let value: CGFloat = expandedView ? 10 : 0
        return feedSession.currentBreastSide == .right ? 0 : value
    }
    
    var body: some View {
        VStack {
            HStack {
                Circle().foregroundColor(self.color)
                .frame(width: self.feedSession.currentBreastSide == .left ? 30 : 15)
                .offset(y: leftOffset)
                .opacity(self.feedSession.currentBreastSide == .left ? 1 : 0.25)
                .overlay(
                    Text("L")
                        .font(.system(size: 10))
                        .foregroundColor(Color(UIColor.systemBackground))
                        .offset(x: 0, y: leftOffset)
                )
                
                Circle().foregroundColor(self.color)
                .frame(width: self.feedSession.currentBreastSide == .right ? 30 : 15)
                .offset(y: rightOffset)
                .opacity(self.feedSession.currentBreastSide == .right ? 1 : 0.25)
                .overlay(
                    Text("R")
                        .font(.system(size: 10))
                        .foregroundColor(Color(UIColor.systemBackground))
                        .offset(x: 0, y: rightOffset)
                )
            }
        }
        .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.5, blendDuration: 0.5))
    }
}

struct BreastSideView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let session = FeedSession(context: context)
        let feed = Feed()
        feed.breastSide = .left
        feed.duration = 23423
        session.addToFeeds(feed)
        
        return BreastSideView(feedSession: session, color: .white).background(Color.red)
    }
}
