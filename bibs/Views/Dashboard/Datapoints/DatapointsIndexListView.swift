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
            
//            #if DEBUG
//                DevelopmentDataActionsView(profile: self.profile)
//            #endif
            
            if self.profile.parent.childrenArray.filter{$0.status == .archived}.count > 0 {
                Divider()
                
                VStack {
                    Text("archived_children".localized).font(.headline)
                    
                    VStack {
                        ForEach(Array(self.profile.parent.childrenArray.filter{$0.status == .archived}), id: \.self) { child in
                            NavigationLink(destination: ChildDataTypeListView(child: child, profile: self.profile)) {
                                HStack {
                                    Text(child.wrappedName).foregroundColor(Color(UIColor.label).opacity(0.75))
                                    Spacer()
                                    Image(systemName: "chevron.right").foregroundColor(Color.white.opacity(0.5))
                                }
                            }
                        }
                    }
                    .padding(5).padding([.leading, .trailing], 5)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .padding()
                .padding(.top, 25)
            }
            
            NavigationLink(destination: ChildEditView(child: profile.parent.buildChildObject()), isActive: self.$showAddChildView) {
                EmptyView()
            }
        }
        .navigationBarTitle("overview".localized)
        .navigationBarItems(trailing: HStack {
            Button("add_child".localized) {
                self.showAddChildView.toggle()
            }
            Image(systemName: "person.circle").foregroundColor(Color(UIColor.systemBlue))
        })
    }
}

struct DatapointsIndexListView_Previews: PreviewProvider {
    static var previews: some View {
        DatapointsIndexListView(profile: ProfileObserver.shared)
    }
}
