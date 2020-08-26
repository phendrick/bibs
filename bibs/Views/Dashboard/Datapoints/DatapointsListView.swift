//
//  DataToolsView.swift
//  bibs
//
//  Created by Paul Hendrick on 06/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DatapointsListView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    @State var expandedLayout = true
    
    var body: some View {
        VStack {
            List {
                NavigationLink(destination: FeedTimersDataView(child: child, profile: self.profile) ) {
                    Text("Breast Feeds")
                }
                
                NavigationLink(destination: BottleFeedsDataView(child: child, profile: self.profile) ) {
                    Text("Bottle Feeds")
                }
                
                NavigationLink(destination: NappyChangesDataView(child: child, profile: self.profile) ) {
                    Text("Nappy Changes")
                }
                
                NavigationLink(destination: WeaningDataView(child: child, profile: self.profile) ) {
                    Text("Snacks")
                }
                
                NavigationLink(destination: NaptimesDataView(child: child, profile: self.profile) ) {
                    Text("Naps")
                }
            }
            
            Spacer()
        }.navigationBarTitle("\(self.child.wrappedName)'s data")
    }
}

struct DataToolsView_Previews: PreviewProvider {
    static var previews: some View {
        DatapointsListView(child: Child(), profile: ProfileObserver.shared)
    }
}
