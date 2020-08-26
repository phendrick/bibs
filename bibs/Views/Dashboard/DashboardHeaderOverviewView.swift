//
//  DashboardHeaderOverviewView.swift
//  bibs
//
//  Created by Paul Hendrick on 24/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardHeaderOverviewView: View {
    @ObservedObject var profile: ProfileObserver
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Today".localized).font(.headline)
                
                Spacer()
                Text("View all data".localized)
                    .font(.footnote)
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }.padding([.leading, .top, .trailing]).padding(.bottom, 5)
            
            Divider().opacity(0.5).offset(y: -10).padding([.leading, .trailing])
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Feeds".localized)
                        .font(.subheadline).padding(.bottom, 10)
                    
                    Text(String.localizedStringWithFormat(NSLocalizedString("%ld tracked %@ today", comment: "todays feed counter"), "feed", profile.parent.todaysFeedsOverview.0))
                        .font(.footnote).foregroundColor(Color(UIColor.secondaryLabel))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
                Divider().frame(height: 50)
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Nappies".localized)
                        .font(.subheadline).padding(.bottom, 10)
                    
                    Text(String.localizedStringWithFormat(NSLocalizedString("%ld and %ld nappies today", comment: "todays feed counter"), profile.parent.todaysNappiesOverview.1, 2, profile.parent.todaysNappiesOverview.2)).font(.footnote).foregroundColor(Color(UIColor.secondaryLabel))
                }.frame(minWidth: 0, maxWidth: .infinity)
                
                Divider().frame(height: 50)
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Naps".localized)
                        .font(.subheadline).padding(.bottom, 10)
                    
                    Text(String.localizedStringWithFormat(NSLocalizedString("%ld tracked %@ today", comment: "todays feed counter"), "feed", profile.parent.todaysNapsOverview.0))
                        .font(.footnote).foregroundColor(Color(UIColor.secondaryLabel))
                }.frame(minWidth: 0, maxWidth: .infinity)
            }
        }
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct DashboardHeaderOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardHeaderOverviewView(profile: ProfileObserver.shared)
                .previewLayout(.fixed(width: 400, height: 180))
            
            DashboardHeaderOverviewView(profile: ProfileObserver.shared)
                .previewLayout(.fixed(width: 400, height: 240))
        }
    }
}
