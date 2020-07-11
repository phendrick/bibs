//
//  BottleFeedsDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct BottleFeedsDataView: View {
    @State var bottleFeedType: BottleFeed.BottleFeedType = .donorMilk
    
    var body: some View {
        VStack {
            Picker(selection: self.$bottleFeedType, label: Text("")) {
                ForEach(BottleFeed.BottleFeedType.allCases, id: \.self) {storage in
                    Text("\(storage.description)").tag(storage.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            DynamicListView(filterKey: "state", filterValue: Int16(self.bottleFeedType.rawValue)) { (result: BottleFeed) in
                HStack {
                    Text("\(result.wrappedCreatedAt.getFormattedDate())")
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
