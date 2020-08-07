//
//  FeedTimersDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FeedTimersDataView: View {
    @Environment(\.managedObjectContext) var moc
    
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    @State var feedSessionType: FeedSession.FeedSessionStatus = .complete
    
    var body: some View {
        VStack {
            DashboardDataView(
                predicate: NSPredicate(format: "%K IN %@ AND child = %@", "state", [self.feedSessionType.rawValue], child),
                profile: self.profile
            ) {(result: FeedSession, count: Int) in
                NavigationLink(destination: EditFeedSessionView(feedSession: result, context: self.moc)) {
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
