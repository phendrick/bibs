//
//  FeedTimersDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FeedTimersDataView: View {
    @State var feedSessionType: FeedSession.FeedSessionStatus = .complete
    
    var body: some View {
        VStack {
            Picker(selection: self.$feedSessionType, label: Text("")) {
                Text("Completed").tag(FeedSession.FeedSessionStatus.complete.rawValue)
                Text("Running").tag(FeedSession.FeedSessionStatus.running.rawValue)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            DashboardDataView(
                predicate: NSPredicate(format: "%K IN %@", "state", [self.feedSessionType.rawValue])
            ) {(result: FeedSession, count: Int) in
                NavigationLink(destination: EditFeedTimeView(feedSession: result)) {
                    HStack {
                        Text("\(result.wrappedCreatedAt.getFormattedDate())")
                    }
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
