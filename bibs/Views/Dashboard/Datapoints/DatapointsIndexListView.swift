//
//  DatapointsIndexListView.swift
//  bibs
//
//  Created by Paul Hendrick on 07/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DatapointsIndexListView: View {
    @ObservedObject var profile: ProfileObserver
    @State var showAddChildView: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ChildrenDashboardListView(profile: self.profile)
                .animation(nil)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding()
            
            Divider()
            
            ParentDashboardDataListView(profile: self.profile)
                .padding()
            
            Spacer()
            
            DevelopmentDataActionsView(profile: self.profile)
            
            NavigationLink(destination: ChildEditView(child: profile.parent.buildChildObject()), isActive: self.$showAddChildView) {
                EmptyView()
            }
        }
        .navigationBarTitle("Overview".localized)
        .navigationBarItems(trailing: HStack {
            Button("Add Child".localized) {
                self.showAddChildView.toggle()
            }
        })
    }
}

struct DatapointsIndexListView_Previews: PreviewProvider {
    static var previews: some View {
        DatapointsIndexListView(profile: ProfileObserver.shared)
    }
}
