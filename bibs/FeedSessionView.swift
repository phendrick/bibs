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
    var feedSession: FeedSession
    
    var things: [String] = ["hello", "weee", "test", "whoops", "what"]
    @State var label: String = "ok"
    @State var seconds = 0
    
    func formatTime(seconds: Int) -> String {
        return ""
    }
    
    var body: some View {
        HStack {
            Text("00:00:00 - \(label)")
            
            Button(action: {
            }) {
                Text("Pause")
            }
            
            Button(action: {
            }) {
                Text("Switch")
            }
        }.onAppear {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
                self.label = self.things.randomElement()!
            }
        }
    }
}

struct FeedSessionView_Previews: PreviewProvider {
    static var previews: some View {
        FeedSessionView(feedSession: FeedSession())
    }
}
