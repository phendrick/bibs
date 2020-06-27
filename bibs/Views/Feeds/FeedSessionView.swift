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
    @EnvironmentObject var feedSession: FeedSession
    
    func buttonIcon(state: FeedSession.FeedSessionStatus) -> String {
        state == .running ? "pause.fill" : "play.fill"
    }
    
    func breastSideIcon(state: Feed.BreastSide?) -> String {
        guard let side = self.feedSession.currentBreastSide else {
            return "circle.lefthalf.fill"
        }
        
        return side == .left ? "circle.lefthalf.fill" : "circle.righthalf.fill"
    }
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text("\(feedSession.formattedElapsedTime(include_hsec: true))")
                    Spacer()
                    Image(systemName: buttonIcon(state: self.feedSession.status))
                }
                .frame(maxWidth: 160)
                .padding()
                .foregroundColor(.white)
                .background(Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)).cornerRadius(15))
                .onTapGesture {
                    if self.feedSession.status == .paused {
                        self.feedSession.resume()
                    }else if self.feedSession.status == .running {
                        self.feedSession.pause()
                    }
                }
                
                HStack {
                    Text("Done")
                }.padding()
                .foregroundColor(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
                .onTapGesture {
                    try? self.feedSession.finish()
                }
                
                HStack {
                    Image(systemName: breastSideIcon(state: self.feedSession.currentBreastSide))
                }.padding()
                .foregroundColor(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
                .onTapGesture {
                    self.feedSession.switchSide()
                }
            }
        }
    }
}

struct FeedSessionView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let session = FeedSession(context: context)
        
        return FeedSessionView().environmentObject(session).environment(\.managedObjectContext, context)
    }
}
