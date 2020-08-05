//
//  DataToolsView.swift
//  bibs
//
//  Created by Paul Hendrick on 06/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DataToolsView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    @State var expandedLayout = true
    
    var body: some View {
        VStack {
            List {
                NavigationLink(destination: FeedTimersDataView(child: child) ) {
                    Text("Breast Feeds")
                }
                
                NavigationLink(destination: BottleFeedsDataView(child: child) ) {
                    Text("Bottle Feeds")
                }
                
                NavigationLink(destination: NappyChangesDataView(child: child) ) {
                    Text("Nappy Changes")
                }
                
                NavigationLink(destination: WeaningDataView(child: child) ) {
                    Text("Snacks")
                }
                
                NavigationLink(destination: NaptimesDataView(child: child) ) {
                    Text("Naps")
                }
                
                NavigationLink(destination: ExpressedMilkDataView(child: child) ) {
                    Text("Expressed Milk")
                }
            }
            
            Spacer()
            
        }.navigationBarTitle("\(self.child.wrappedName)'s data")
    }
}

struct DataToolsView_Previews: PreviewProvider {
    static var previews: some View {
        DataToolsView(child: Child(), profile: ProfileObserver.shared)
    }
}
