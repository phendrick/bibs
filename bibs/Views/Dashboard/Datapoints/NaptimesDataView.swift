//
//  BottleFeedsDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 11/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct NaptimesDataView: View {
    @ObservedObject var child: Child
    @ObservedObject var profile: ProfileObserver
    
    var body: some View {
        VStack {
            DashboardDataView(
                predicate: NSPredicate(format: "child = %@", child),
                profile: self.profile
            ) {(result: Nap, count: Int) in
                VStack(alignment: .leading, spacing: 15) {
                    Text("\(result.duration.formattedHoursAndMinutes)")
                    Text("\(result.wrappedCreatedAt.getFormattedDate())").foregroundColor(.gray)
                }.padding([.top, .bottom])
            }
            
            Spacer()
        }
        .navigationBarTitle(Text("Nap Times"), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct BottleFeedsDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottleFeedsDataView()
//    }
//}
