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
    @Binding var expandedLayout: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    HStack(spacing: 5) {
                        Text("\(self.feedSession.child?.wrappedName ?? "") feeding from")
                            .font(.caption)
                        Text(self.feedSession.currentBreastSide.description.0.lowercased())
                            .padding(5)
                            .frame(width: 70)
                            .onTapGesture {
                                self.feedSession.switchSide()
                            }
                            .overlay(Capsule().stroke(Color.white, lineWidth: 1))
                        .font(.caption)
                    }
                    
                    Spacer()
                    
                    if self.feedSession.status == .paused {
                        Button("Complete") {
                            withAnimation {
                                self.profile.objectWillChange.send()
                                self.feedSession.complete()
                            }
                        }
                        .font(.caption)
                        .padding(5)
                        .overlay(
                            Capsule()
                                .stroke(Color.white, lineWidth: 1)
                                .frame(width: 70)
                        )
                    }
                }
                
                Spacer()
                
                HStack(alignment: .center) {
                    Text("\(feedSession.formattedElapsedTime())").font(.custom("RobotoMono-Regular", size: 22)).padding(4)
                    
                    Spacer()
                    
                    Image(systemName: self.feedSession.status == .paused ? "play" : "pause")
                        .animation(nil)
                        .frame(width: 40, height: 40)
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
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(self.color)
        .foregroundColor(.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 0, x: 0, y: 10)
        
//        HStack(alignment: .top) {
//            VStack(alignment: .leading) {
//                Text("No Active timer").font(.headline)
//
//                HStack {
//                    FeedSessionTimerView(profile: profile, feedSession: feedSession)
//                    FeedSessionTimerActions(profile: profile, feedSession: feedSession)
//                }
//            }
//            .padding([.leading, .trailing])
//            .padding([.top, .bottom])
//        }
//        .frame(maxWidth: .infinity)
//        .background(self.color)
//        .foregroundColor(.white)
//        .cornerRadius(10)
//        .onAppear {
//            print(self.feedSession)
//        }
    }
}

//struct DashboardFeedTimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            DashboardFeedTimerView(
//                color: .green, expandedLayout: .constant(false)
//            ).previewLayout(.fixed(width: 360, height: 280))
//
//            DashboardFeedTimerView(
//                color: .green, expandedLayout: .constant(true)
//            ).previewLayout(.fixed(width: 360, height: 280))
//        }
//    }
//}
