//
//  FeedSessionView.swift
//  bibs
//
//  Created by Paul Hendrick on 31/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import Foundation

struct FeedSessionView: View {
    var cofeeding: Bool = false
    var cofeedingIndex: Int = 0
    
    @ObservedObject var feedSession: FeedSession
    
    func buttonIcon(state: FeedSession.FeedSessionStatus) -> String {
        state == .running ? "pause.fill" : "play.fill"
    }
    
    func breastSideIcon(state: Feed.BreastSide?) -> String {
        "circle.lefthalf.fill"
//        guard let side = self.feedSession.currentBreastSide else {
//            return "circle.lefthalf.fill"
//        }
//
//        return side == .left ? "circle.lefthalf.fill" : "circle.righthalf.fill"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("\(feedSession.status.rawValue) - ")
                Text("\(feedSession.formattedElapsedTime())")
                    .onTapGesture {
                        if self.feedSession.status == .paused {
                            self.feedSession.resume()
                        }else if self.feedSession.status == .running {
                            self.feedSession.pause()
                        }
                    }
                
                Text("< - >").onTapGesture {
                    self.feedSession.switchSide()
                }
                
                if cofeeding {
                    Text("\(self.feedSession.child?.wrappedName ?? "")")
                }
            }
        }
        .font(.custom("RobotoMono-Regular", size: 20))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
//            ForEach(activeFeedSessions.indices) {sessionIndex in
//                VStack {
//                    if sessionIndex == 1 {
//                        VStack(alignment: .center) {
//                            HStack(alignment: .firstTextBaseline) {
//                                Text("Milo")
//                                Image(systemName: "link").rotationEffect(.degrees(-45)).foregroundColor(.orange)
//                                Text("Tabitha")
//                            }
//                        }
//                        .font(.custom("OpenSans-Regular", size: 14)).minimumScaleFactor(0.5)
//                        .offset(y: -5)
//                    }
//
//                    HStack {
//                        Text("\(self.activeFeedSessions[sessionIndex].formattedElapsedTime())")
//                            .font(.custom("RobotoMono-Regular", size: 22))
//                            .padding()
//
//                        Image(systemName: "pause.fill")
//                            .padding(.trailing, 15)
//                    }
//                    .foregroundColor(.white)
//                    .background(
//                        Capsule(style: .continuous)
//                            .foregroundColor(
//                                Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)).opacity(0.7)
//                            )
//                    )
//                    .onTapGesture {
//                        if self.activeFeedSessions[sessionIndex].status == .paused {
//                            self.activeFeedSessions[sessionIndex].resume()
//                        }else if self.activeFeedSessions[sessionIndex].status == .running {
//                            self.activeFeedSessions[sessionIndex].pause()
//                        }
//                    }
//                }
//            }
//        }
//    }
    
//    var body: some View {
//        VStack {
//            HStack {
//                HStack {
//                    Text("00:00:00.00")
//                        .font(.system(.body, design: .monospaced))
//                    Spacer()
////                    Image(systemName: buttonIcon(state: self.feedSession.status))
//                }
//                .frame(maxWidth: 160)
//                .padding()
//                .foregroundColor(.white)
//                .background(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)).cornerRadius(15))
//                .onTapGesture {
////                    if self.feedSession.status == .paused {
////                        self.feedSession.resume()
////                    }else if self.feedSession.status == .running {
////                        self.feedSession.pause()
////                    }
//                }
//
//                HStack {
//                    Text("Done")
//                }.padding()
//                .foregroundColor(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
//                .onTapGesture {
//                    //try? self.feedSession.finish()
//                }
//
////                HStack {
////                    Image(systemName: breastSideIcon(state: self.feedSession.currentBreastSide))
////                }.padding()
////                .foregroundColor(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
////                .onTapGesture {
////                    self.feedSession.switchSide()
////                }
//            }
//        }
//    }
}

struct FeedSessionView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let session = FeedSession(context: context)
        
        return FeedSessionView(feedSession: session).environment(\.managedObjectContext, context)
    }
}
