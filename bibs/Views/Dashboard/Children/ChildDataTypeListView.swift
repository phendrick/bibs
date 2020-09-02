//
//  ChildDataTypeListView.swift
//  bibs
//
//  Created by Paul Hendrick on 31/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChildDataTypeListView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    var body: some View {
        VStack {
            NavigationLink(destination: FeedSessionChildChartsView(child: child, profile: self.profile)) {
                VStack(alignment: .leading) {
                    Text("feed session charts")
                }
            }
            
            NavigationLink(destination: BottleFeedChildChartsView(child: child, profile: self.profile)) {
                VStack(alignment: .leading) {
                    Text("bottle feed charts")
                }
            }
            
            NavigationLink(destination: NapTimeChildChartsView(child: child, profile: self.profile)) {
                VStack(alignment: .leading) {
                    Text("nap time charts")
                }
            }
            
            NavigationLink(destination: NappyChangeChildChartsView(child: child, profile: self.profile)) {
                VStack(alignment: .leading) {
                    Text("nappy change charts")
                }
            }
            
            Divider()
            
            NavigationLink(destination: DatapointsListView(child: child, profile: self.profile)) {
                VStack(alignment: .leading) {
                    Text("edit data")
                }
            }
            
            Spacer()
        }
    }
}

//struct ChildDataTypeListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChildDataTypeListView()
//    }
//}
