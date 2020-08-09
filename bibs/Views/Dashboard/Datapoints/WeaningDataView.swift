//
//  BottleFeedsDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct WeaningDataView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    @State var snackType: Snack.SnackType = .fruit
    
    var body: some View {
        VStack {
            Picker(selection: self.$snackType, label: Text("")) {
                ForEach(Snack.SnackType.allCases, id: \.self) {snack in
                    Text("\(snack.description)").tag(snack.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            DashboardDataView(
                profile: self.profile,
                predicate: NSPredicate(format: "%K IN %@ AND child = %@", "state", [self.snackType.rawValue], child),
                sortDescriptors: [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ]
            ) {(result: Snack, count: Int) in
                NavigationLink(destination: EditSnackView(profile: self.profile, snack: result)) {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("\(result.snackType.description) ") +
                            Text(result.note ?? "")
                        }
                        
                        Text("\(result.wrappedCreatedAt.getFormattedDate())").foregroundColor(.gray)
                    }.padding([.top, .bottom])
                }
            }
            
            Spacer()
        }
        .navigationBarTitle(Text("Weaning"), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct BottleFeedsDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottleFeedsDataView()
//    }
//}
