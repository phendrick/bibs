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
            VStack(alignment: .leading, spacing: 0) {
                ForEach(profile.parent.activeChildrenArray, id: \.self) {child in
                    HStack {
                        NavigationLink(destination: ChildDataTypeListView(child: child, profile: self.profile)) {
                            HStack {
                                Text(child.wrappedName).foregroundColor(Color.white)
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(Color.white.opacity(0.5))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .animation(.easeInOut)
                    .padding(10)
                    .background(Color(child.theme.0))
                    .onTapGesture {
                        self.profile.parent.activeChild = child
                        self.profile.objectWillChange.send()
                    }
                }
            }
        }
    }
}

struct ChildrenDashboardListView_Previews: PreviewProvider {
    static var previews: some View {
        ChildrenDashboardListView(profile: ProfileObserver.shared)
    }
}
