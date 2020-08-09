//
//  ExpressedMilkDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 10/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ExpressedMilkDataView: View {
    @ObservedObject var profile: ProfileObserver
    
    @State var expressedBottleStorageType: ExpressedBottle.ExpressedBottleStorageStatus = .refridgerated
    
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
                profile: self.profile,
                predicate: NSPredicate(format: "%K IN %@", "state", [self.expressedBottleStorageType.rawValue]),
                sortDescriptors: [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ]
            ) {(result: ExpressedBottle, count: Int) in
                NavigationLink(destination: EditExpressedMilkView(profile: self.profile, expressedBottle: result)) {
                    HStack {
                        Text("\(result.convertedAmount) ")
                        Text("\(result.wrappedCreatedAt.getFormattedDate())")
                    }
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
