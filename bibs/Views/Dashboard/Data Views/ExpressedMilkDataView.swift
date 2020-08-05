//
//  ExpressedMilkDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 10/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ExpressedMilkDataView: View {
    @ObservedObject var child: Child
    @State var expressedBottleStorageType: ExpressedBottle.ExpressedBottleStorageStatus = .fresh
    
    var body: some View {
        VStack {
            Picker(selection: self.$expressedBottleStorageType, label: Text("")) {
                ForEach(ExpressedBottle.ExpressedBottleStorageStatus.allCases, id: \.self) {storage in
                    Text("\(storage.description)").tag(storage.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            DashboardDataView(
                predicate: NSPredicate(format: "%K IN %@", "state", [self.expressedBottleStorageType.rawValue])
            ) {(result: ExpressedBottle, count: Int) in
                HStack {
                    Text("\(result.convertedAmount) ")
                    Text("\(result.wrappedCreatedAt.getFormattedDate())")
                }
            }
            
            Spacer()
        }
        .navigationBarTitle(Text("Expressed Milk"), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct ExpressedMilkDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpressedMilkDataView()
//    }
//}
