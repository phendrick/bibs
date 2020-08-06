//
//  BottleFeedsDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct BottleFeedsDataView: View {
    @ObservedObject var child: Child
    @State var bottleFeedType: BottleFeed.BottleFeedType = .expressedMilk
    
    var body: some View {
        VStack {
            Picker(selection: self.$bottleFeedType, label: Text("")) {
                ForEach(BottleFeed.BottleFeedType.allCases, id: \.self) {storage in
                    Text("\(storage.description)").tag(storage.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            DashboardDataView(
                predicate: NSPredicate(format: "%K IN %@", "state", [self.bottleFeedType.rawValue])
            ) {(result: BottleFeed, count: Int) in
                HStack {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("\(result.amount)ml").fontWeight(.bold)  +
                            Text(" at ") + 
                            Text("\(result.wrappedCreatedAt.getFormattedDate())").foregroundColor(.gray)
                        }
                    }.padding([.top, .bottom])
                }
            }
            
            Spacer()
        }
        .navigationBarTitle(Text("Bottle Feeds"), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct BottleFeedsDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottleFeedsDataView()
//    }
//}
