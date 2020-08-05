//
//  ChildrenDashboardListView.swift
//  bibs
//
//  Created by Paul Hendrick on 01/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChildrenDashboardListView: View {
    @ObservedObject var profile: ProfileObserver
    
    var body: some View {
        VStack {
            VStack {
                List(self.profile.parent.activeChildrenArray) { child in
                    NavigationLink(destination: DataToolsView(child: child, profile: self.profile)) {
                        Text("\(child.wrappedName)")
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationBarTitle("Children")
        }
    }
}

struct ChildrenDashboardListView_Previews: PreviewProvider {
    static var previews: some View {
        ChildrenDashboardListView(profile: ProfileObserver.shared)
    }
}
