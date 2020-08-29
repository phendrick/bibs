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
                        NavigationLink(destination: FeedSessionChildChartsView(child: child, profile: self.profile)) {
                            VStack(alignment: .leading) {
                                Text("test")
                            }
                        }
//                        NavigationLink(destination: DatapointsListView(child: child, profile: self.profile)) {
//                            VStack(alignment: .leading) {
//                                Text("\(child.wrappedName)")
//                                    .font(.callout)
//                                    .padding(.bottom, 5)
//                                    .foregroundColor(.white)
//                                    .animation(nil)
//                            }
//
//                            Spacer()
//
//                            Image(systemName: "chevron.right").foregroundColor(Color.white.opacity(0.75))
//                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .animation(.easeInOut)
                    .padding(10)
                    .background(child.theme.0)
                    .onTapGesture {
                        self.profile.parent.activeChild = child
                        self.profile.objectWillChange.send()
                    }
                }
            }
            .cornerRadius(15)
            .navigationBarTitle("Overview".localized)
        }
    }
}

struct ChildrenDashboardListView_Previews: PreviewProvider {
    static var previews: some View {
        ChildrenDashboardListView(profile: ProfileObserver.shared)
    }
}
