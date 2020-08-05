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
                predicate: NSPredicate(format: "%K IN %@", "state", [self.nappyChangeType.rawValue])
            ) {(result: NappyChange, count: Int) in
                VStack {
                    HStack {
                        Text("\(result.status.description) ")
                        Text("\(result.wrappedCreatedAt.getFormattedDate())")
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
