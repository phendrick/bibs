//
//  ParentFoodDiaryListView.swift
//  bibs
//
//  Created by Paul Hendrick on 08/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ParentFoodDiaryListView: View {
    @ObservedObject var profile: ProfileObserver
    
    var body: some View {
        VStack {
            DashboardDataView(
                //predicate: NSPredicate(format: "%K IN %@", "state", [self.bottleFeedType.rawValue]),
                profile: self.profile,
                sortDescriptors: [
                    NSSortDescriptor(key: "createdAt", ascending: false)
                ]
            ) {(result: FoodDiaryEntry, count: Int) in
                HStack {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("\(result.foodType.emoji)")
                            Text("\(result.foodType.description)").fontWeight(.bold)
                        }
                        HStack {
                            Text("\(result.wrappedCreatedAt.getFormattedDate())").foregroundColor(.gray)
                        }
                    }.padding([.top, .bottom])
                }
            }
        .navigationBarTitle("Food Diary")
        }
    }
}

struct ParentFoodDiaryListView_Previews: PreviewProvider {
    static var previews: some View {
        ParentFoodDiaryListView(profile: ProfileObserver.shared)
    }
}
