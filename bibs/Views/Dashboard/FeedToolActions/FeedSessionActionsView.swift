//
//  FeedSessionActionsView.swift
//  bibs
//
//  Created by Paul Hendrick on 06/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FeedSessionActionsView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    @FetchRequest(
        entity: FeedSession.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "state == %d", Int16(FeedSession.FeedSessionStatus.complete.rawValue)),
        animation: .spring()) var completedFeedSessions: FetchedResults<FeedSession>
    
    var body: some View {
        HStack {
            Button(action: {
                do {
                    try self.profile.parent.activeChild?.startNewFeedSession()
                }catch {
                }
            }) {
                HStack {
                    Text("New session")
                    Spacer()
                }.padding()
            }
            
            Button(action: {
                self.profile.parent.activeChild?.clear()
            }) {
                HStack {
                    Text("Clear out")
                    Spacer()
                }.padding()
            }
            
            NavigationLink(destination: FeedTimersDataView().environment(\.managedObjectContext, self.moc)) {
                Text("Manage Feeds")
            }
        }.background(Color.orange)
    }
}

struct FeedSessionActionsView_Previews: PreviewProvider {
    static var previews: some View {
        FeedSessionActionsView()
    }
}
