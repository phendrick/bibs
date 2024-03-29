//
//  ParentDashboardDataListView.swift
//  bibs
//
//  Created by Paul Hendrick on 08/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ParentDashboardDataListView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var profile: ProfileObserver
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("about_you".localized).font(.caption)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    NavigationLink(destination: ParentEmotionListView(profile: self.profile).environment(\.managedObjectContext, self.moc)) {
                        VStack(alignment: .leading) {
                            Text("emotions_and_insights".localized)
                                .font(.callout)
                                .padding(.bottom, 5)
                                .foregroundColor(Color(UIColor.label).opacity(0.75))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right").foregroundColor(Color.gray.opacity(0.5))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color(UIColor.systemFill))
                
                HStack {
                    NavigationLink(destination: ParentFoodDiaryListView(profile: self.profile).environment(\.managedObjectContext, self.moc)) {
                        VStack(alignment: .leading) {
                            Text("food_diary".localized)
                                .font(.callout)
                                .padding(.bottom, 5)
                                .foregroundColor(Color(UIColor.label).opacity(0.75))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right").foregroundColor(Color.gray.opacity(0.5))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color(UIColor.tertiarySystemFill))
                
                HStack {
                    NavigationLink(destination: ExpressedMilkDataView(profile: self.profile).environment(\.managedObjectContext, self.moc)) {
                        VStack(alignment: .leading) {
                            Text("stored_milk".localized)
                                .font(.callout)
                                .padding(.bottom, 5)
                                .foregroundColor(Color(UIColor.label).opacity(0.75))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right").foregroundColor(Color.gray.opacity(0.5))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(Color(UIColor.systemFill))
            }
            .cornerRadius(15)
        }
    }
}

struct ParentDashboardDataListView_Previews: PreviewProvider {
    static var previews: some View {
        ParentDashboardDataListView(profile: ProfileObserver.shared)
    }
}
