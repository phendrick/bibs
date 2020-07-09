//
//  SwiftUIView.swift
//  bibs
//
//  Created by Paul Hendrick on 07/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ActiveFeedsPreview: View {
    var profile: ProfileObserver
    
    var body: some View {
        VStack {
            ForEach(profile.parent.activeFeedSessions.indices) { sessionIndex in
                HStack {
                    Spacer()
                    
                    Text("\(self.profile.parent.activeFeedSessions[sessionIndex].child?.wrappedName ?? "")")
                    
                    FeedSessionTimerView(
                        feedSession: self.profile.parent.activeFeedSessions[sessionIndex]
                    )
                    
                    Spacer()
                    
                    FeedSessionTimerActions(feedSession: self.profile.parent.activeFeedSessions[sessionIndex])
                }
                .font(.custom("RobotoMono-Regular", size: 20))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(self.profile.parent.activeFeedSessions[sessionIndex].child?.themeColor ?? .clear)
                        .shadow(color: Color.gray.opacity(0.2), radius: 0, x: 0, y: 6)
                ).foregroundColor(.white)
            }
            .padding(.top, 10)
        }
    }
}

struct ActiveFeedsPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveFeedsPreview(profile: .shared)
    }
}
