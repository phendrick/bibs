//
//  NappyChangeDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct NappyChangesDataView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    @State var nappyChangeType: NappyChange.NappyChangeType = .wet
    
    var body: some View {
        VStack {
            Picker(selection: self.$nappyChangeType, label: Text("")) {
                ForEach(NappyChange.NappyChangeType.allCases, id: \.self) {nappy in
                    Text("\(nappy.description)").tag(nappy.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            DashboardDataView(
                profile: self.profile,
                predicate: NSPredicate(format: "%K IN %@", "state", [self.nappyChangeType.rawValue]),
                sortDescriptors: [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ]
            ) {(result: NappyChange, count: Int) in
                NavigationLink(destination: EditNappyChangeView(profile: self.profile, nappyChange: result)) {
                    VStack {
                        HStack {
                            Text("\(result.status.description) ")
                            Text("\(result.wrappedCreatedAt.getFormattedDate())")
                        }
                    }
                }
            }
            
            Spacer()
        }
        .navigationBarTitle(Text("Nappy Changes"), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct NappyChangeDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        NappyChangeDataView()
//    }
//}
