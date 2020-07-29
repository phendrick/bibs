//
//  Used on the dashboard when the currently active tool is not the feeds tool 
//
//
//  SwiftUIView.swift
//  bibs
//
//  Created by Paul Hendrick on 07/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ActiveFeedsPreview: View {
    @ObservedObject var profile: ProfileObserver
    
    var body: some View {
        VStack {
            ForEach(profile.parent.currentFeedSessions, id: \.self) { session in
                HStack {
                    Spacer()

                    FeedSessionTimerView(
                        profile: self.profile,
                        feedSession: session,
                        expandedView: false
                    )

                    Spacer()

                    FeedSessionTimerActions(
                        profile: self.profile,
                        feedSession: session,
                        expandedView: false
                    )
                }
                .font(.custom("RobotoMono-Regular", size: 20))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(session.child?.themeColor ?? .clear)
                        .shadow(color: Color.gray.opacity(0.2), radius: 0, x: 0, y: 6)
                ).foregroundColor(.white)
            }
        }
    }
}

//struct ActiveFeedsPreviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActiveFeedsPreview().environmentObject(ProfileObserver.shared)
//    }
//}
