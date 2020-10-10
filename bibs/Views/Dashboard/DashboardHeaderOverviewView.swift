//
//  DashboardHeaderOverviewView.swift
//  bibs
//
//  Created by Paul Hendrick on 24/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardHeaderOverviewItem: View {
    var title: String
    var value: String?
    var count: Int?
    var date: Date?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(spacing: 10) {
                HStack {
                    HStack {
                        Text(title).font(.headline).foregroundColor(.orange)
                        
                        Spacer()
                        if count == nil {
                            Text("no_data".localized)
                                .foregroundColor(Color(UIColor.quaternaryLabel))
                                .font(.callout)
                        }
                    }
                    
                    Spacer()
                    
                    if date != nil {
                        Text("latest_at".localized)
                            .font(.callout).fontWeight(.bold)
                            .foregroundColor(Color(UIColor.tertiaryLabel)) +
                        Text(date!.getFormattedDate(format: " h:mm a"))
                            .font(.callout)
                            .foregroundColor(Color(UIColor.quaternaryLabel))
                    }
                }
                
                HStack {
                    if count != nil {
                        Text(value!).font(.headline).foregroundColor(Color(UIColor.label))
                    }
                    
                    Spacer()
                }.foregroundColor(Color.black.opacity(0.75))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .bottom], 10)
        }
        .animation(.linear)
        .padding(5).padding([.leading, .trailing], 5)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
    }
}

struct DashboardHeaderOverviewView: View {
    @ObservedObject var profile: ProfileObserver
    
    var feedsValue: String {
        String.localizedStringWithFormat(NSLocalizedString("%ld feeds", comment: "number of feeds"), profile.parent.todaysFeedsOverview.0 ?? 0)
    }
    
    var nappyChangesValue: String {
        String.localizedStringWithFormat(NSLocalizedString("%ld nappy changes", comment: "number of nappy changes"), profile.parent.todaysNappiesOverview.0 ?? 0)
    }
    
    var napsValue: String {
        String.localizedStringWithFormat(NSLocalizedString("%ld naps", comment: "number of naps"), profile.parent.todaysNapsOverview.0 ?? 0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("today_so_far".localized).font(.headline)
                Spacer()
                
                Text("view_data".localized)
                    .foregroundColor(.gray).font(.subheadline)
            }
            
            DashboardHeaderOverviewItem(
                title: "feeds".localized,
                value: feedsValue,
                count: profile.parent.todaysFeedsOverview.0, date: profile.parent.todaysFeedsOverview.2
            )
            
            DashboardHeaderOverviewItem(
                title: "nappy_changes".localized,
                value: nappyChangesValue,
                count: profile.parent.todaysNappiesOverview.0,
                date: profile.parent.todaysNappiesOverview.3
            )
            
            DashboardHeaderOverviewItem(
                title: "nap_times".localized,
                value: napsValue,
                count: profile.parent.todaysNapsOverview.0,
                date: profile.parent.todaysNapsOverview.2
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(y: -30)
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
