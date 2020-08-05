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
                NavigationLink(destination: TimelineView().environmentObject(self.profile)) {
                    Text("Breast Feeds")
                }
                
                NavigationLink(destination: Text("Data")) {
                    Text("Bottle Feeds")
                }
                
                NavigationLink(destination: Text("Data")) {
                    Text("Nappy Changes")
                }
                
                NavigationLink(destination: Text("Data")) {
                    Text("Snacks")
                }
                
                NavigationLink(destination: Text("Data")) {
                    Text("Naps")
                }
                
                NavigationLink(destination: Text("Data")) {
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
