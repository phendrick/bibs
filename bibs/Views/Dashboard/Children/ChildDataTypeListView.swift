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
    
    @State var showChildEditView: Bool = false

    var body: some View {
        VStack {
            List {
                NavigationLink(destination: FeedSessionChildChartsView(child: child, profile: self.profile)) {
                    Text("breastfeeds".localized)
                }
                
                NavigationLink(destination: BottleFeedChildChartsView(child: child, profile: self.profile)) {
                    Text("bottle_feeds".localized)
                }
                
                NavigationLink(destination: NapTimeChildChartsView(child: child, profile: self.profile)) {
                    Text("nap_times".localized)
                }
                
                NavigationLink(destination: NappyChangeChildChartsView(child: child, profile: self.profile)) {
                    Text("nappy_changes".localized)
                }
                
                NavigationLink(destination: WeaningDataView(child: child, profile: self.profile) ) {
                    Text("snacks_and_weaning".localized)
                }
            }
            
            NavigationLink(destination: ChildEditView(child: self.child), isActive: self.$showChildEditView) {
                EmptyView()
            }
        }
        .navigationBarTitle(String(format: "childs_data".localized, self.child.wrappedName))
        .navigationBarItems(trailing: HStack {
            Button(String(format: "edit_child".localized, self.child.wrappedName)) {
                self.showChildEditView.toggle()
            }
        })
    }
}

//struct ChildDataTypeListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChildDataTypeListView()
//    }
//}
 
