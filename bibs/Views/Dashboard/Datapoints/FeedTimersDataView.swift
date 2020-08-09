//
//  FeedTimersDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FeedTimersDataView: View {    
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    @State var feedSessionType: FeedSession.FeedSessionStatus = .complete
    
    @ViewBuilder func aggregateCallback(results: [FeedSession]) -> some View {
        return VStack {
            Text("Hello")
        }
    }
    
    var body: some View {
        VStack {
            DashboardDataView(
                profile: self.profile,
                predicate: NSPredicate(format: "%K IN %@ AND child = %@", "state", [self.feedSessionType.rawValue], child),
                sortDescriptors: [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ]
            ) {(result: FeedSession, count: Int) in
                NavigationLink(destination: EditFeedSessionView(profile: self.profile, feedSession: result)) {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("\(result.formattedElapsedTime(include_hsec: false))")
                        }
                        
                        Text("\(result.wrappedCreatedAt.getFormattedDate())").foregroundColor(.gray)
                    }.padding([.top, .bottom])
                }
            }
            
            Spacer()
        }
        .navigationBarTitle(Text("Feed Timers"), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}
//
//struct FeedTimersDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedTimersDataView()
//    }
//}
