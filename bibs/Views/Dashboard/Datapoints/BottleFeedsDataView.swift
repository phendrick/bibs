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
    @ObservedObject var profile: ProfileObserver
    @Environment(\.managedObjectContext) var moc
    
    @State var bottleFeedType: BottleFeed.BottleFeedType = .expressedMilk
    
    @ViewBuilder func aggregateCallback(results: [FeedSession]) -> some View {
        return VStack {
            Text("Hello")
        }
    }
    
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
                profile: self.profile,
                predicate: NSPredicate(format: "%K IN %@", "state", [self.bottleFeedType.rawValue]),
                sortDescriptors: [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ]
            ) {(result: BottleFeed, count: Int) in
                NavigationLink(destination: EditBottleFeedView(profile: self.profile, bottleFeed: result)) {
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
