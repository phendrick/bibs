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
                Text("Today").font(.headline)
                
                Spacer()
                Text("View all data")
                    .font(.footnote)
                    .foregroundColor(Color(UIColor.secondaryLabel))
            }.padding([.leading, .top, .trailing]).padding(.bottom, 5)
            
            Divider().opacity(0.5).offset(y: -10).padding([.leading, .trailing])
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("\(profile.parent.todaysFeedsOverview.0) \("feed".pluralize(count: profile.parent.todaysFeedsOverview.0))")
                        .font(.subheadline).padding(.bottom, 10)
                    Text("\(profile.parent.todaysFeedsOverview.1)")
                        .font(.footnote).foregroundColor(Color(UIColor.secondaryLabel))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
                Divider().frame(height: 50)
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Nappies")
                        .font(.subheadline).padding(.bottom, 10).lineLimit(1)
                    
                    HStack {
                        HStack(spacing: 5) {
                            Text("\(profile.parent.todaysNappiesOverview.1)")
                            Text("wet")
                        }.font(.footnote).foregroundColor(Color(UIColor.secondaryLabel))
                        
                        HStack(spacing: 5) {
                            Text("\(profile.parent.todaysNappiesOverview.2)")
                            Text("dirty")
                        }.font(.footnote).foregroundColor(Color(UIColor.secondaryLabel))
                    }
                }.frame(minWidth: 0, maxWidth: .infinity)
                
                Divider().frame(height: 50)
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Naps")
                        .font(.subheadline).padding(.bottom, 10).lineLimit(1)
                    Text("\(profile.parent.todaysNapsOverview.1)")
                        .font(.caption).foregroundColor(Color(UIColor.secondaryLabel))
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
