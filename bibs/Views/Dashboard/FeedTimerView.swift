//
//  FeedTimerView.swift
//  bibs
//
//  Created by Paul Hendrick on 06/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FeedTimerView: View {
    var layout: ActiveFeedsTrayView.ExpandedState = .minimised
    var cofeeding: Bool = true
    
    @ViewBuilder func timerView() -> some View {
        if self.layout == .expanded {
            VStack(alignment: .leading, spacing: 10) {
                Text("00:00:00.99")
            }
        }else if self.layout == .minimal {
            VStack(alignment: .leading, spacing: 10) {
                Text("00:00:00.99")
            }
        }else {
            HStack(spacing: 10) {
                Text("00:00:00.99")
            }
        }
    }
    
    @ViewBuilder func actionsView() -> some View {
        if self.layout == .expanded {
            HStack {
                Text("Paul")
                
                Text("(Left)")
                
                Text("||")
            }
        }else if self.layout == .minimal {
            HStack {
                Text("Paul")
                
                Text("(Left)")
                
                Text("||")
            }
        }else {
            HStack {
                Text("(Left)")
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Paul")
                Spacer()
                
                HStack(spacing: 20) {
                    Text("(LEFT)")
                    Text("||")
                }
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Text("00:00:00.123")
                Spacer()
            }
        }
        .frame(maxHeight: 100)
        .frame(maxWidth: .infinity)
        .background(Color.orange)
    }
}

struct FeedTimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeedTimerView(layout: .expanded, cofeeding: false)
                .previewLayout(.fixed(width: 420, height: 220))
            
            FeedTimerView(layout: .minimal, cofeeding: false)
                .previewLayout(.fixed(width: 420, height: 160))
            
            FeedTimerView(layout: .minimised, cofeeding: false)
                .previewLayout(.fixed(width: 400, height: 100))
            
            FeedTimerView(layout: .minimised, cofeeding: true)
                .previewLayout(.fixed(width: 200, height: 100))
        }
    }
}
