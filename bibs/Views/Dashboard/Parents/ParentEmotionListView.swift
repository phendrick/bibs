//
//  ParentEmotionListView.swift
//  bibs
//
//  Created by Paul Hendrick on 08/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ParentEmotionListView: View {
    @ObservedObject var profile: ProfileObserver
    
    var body: some View {
        VStack {
            DashboardDataView(
                profile: self.profile,
                sortDescriptors: [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ]
            ) {(result: Emotion, count: Int) in
                HStack {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("\(result.status.emoji)")
                            Text("\(result.status.description)").fontWeight(.bold)
                        }
                        HStack {
                            Text("\(result.wrappedCreatedAt.getFormattedDate())").foregroundColor(.gray)
                        }
                    }.padding([.top, .bottom])
                }
            }
        }.navigationBarTitle("Emotions")
    }
}

struct ParentEmotionListView_Previews: PreviewProvider {
    static var previews: some View {
        ParentEmotionListView(profile: ProfileObserver.shared)
    }
}
