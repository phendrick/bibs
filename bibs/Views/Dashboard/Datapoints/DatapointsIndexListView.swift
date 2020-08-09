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
    
    var body: some View {
        VStack {
            ChildrenDashboardListView(profile: self.profile).padding()
            
            Divider()
            
            ParentDashboardDataListView(profile: self.profile).padding()
            
            Spacer()
        }
    }
}

struct DatapointsIndexListView_Previews: PreviewProvider {
    static var previews: some View {
        DatapointsIndexListView(profile: ProfileObserver.shared)
    }
}
