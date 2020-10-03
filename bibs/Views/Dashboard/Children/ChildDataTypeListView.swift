//
//  ChildDataTypeListView.swift
//  bibs
//
//  Created by Paul Hendrick on 31/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChildDatatypeCardView: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(title)
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .resizable()
                    .frame(width: 5, height: 10)
                    .foregroundColor(.secondary)
            }
            .frame(alignment: .top)
        }
        .padding()
        .foregroundColor(.primary)
        .padding()
    }
}

struct ChildDataTypeListView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    @State var showChildEditView: Bool = false

    var body: some View {
        VStack {
            List {
                NavigationLink(destination: FeedSessionChildChartsView(child: child, profile: self.profile)) {
                    Text("Breastfeeds".localized)
                }
                
                NavigationLink(destination: BottleFeedChildChartsView(child: child, profile: self.profile)) {
                    Text("Bottle Feeds".localized)
                }
                
                NavigationLink(destination: NapTimeChildChartsView(child: child, profile: self.profile)) {
                    Text("Nap Times".localized)
                }
                
                NavigationLink(destination: NappyChangeChildChartsView(child: child, profile: self.profile)) {
                    Text("Nappy Changes".localized)
                }
                
                NavigationLink(destination: WeaningDataView(child: child, profile: self.profile) ) {
                    Text("Snacks & Weaning".localized)
                }
            }
            
            NavigationLink(destination: ChildEditView(child: self.child), isActive: self.$showChildEditView) {
                EmptyView()
            }
        }
        .navigationBarTitle("\(self.child.wrappedName)'s Data")
        .navigationBarItems(trailing: HStack {
            Button("Edit \(self.child.wrappedName)") {
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
 
