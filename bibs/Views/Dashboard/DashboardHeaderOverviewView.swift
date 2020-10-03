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
                            Text("No data available".localized)
                                .foregroundColor(Color(UIColor.quaternaryLabel))
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                    
                    if date != nil {
                        Text("Latest at ".localized)
                            .font(.caption).fontWeight(.bold)
                            .foregroundColor(Color(UIColor.tertiaryLabel)) +
                        Text(date!.getFormattedDate(format: "h:mm a"))
                            .font(.caption)
                            .foregroundColor(Color(UIColor.quaternaryLabel))
                    }
                }
                
                HStack {
                    if count != nil {
                        Text(value!).font(.headline)
                    }
                    
                    Spacer()
                }.foregroundColor(Color.black.opacity(0.75))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.top, .bottom], 10)
        }
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
                Text("Today so far".localized).font(.headline)
                Spacer()
            }
            
            DashboardHeaderOverviewItem(
                title: "Feeds".localized,
                value: feedsValue,
                count: profile.parent.todaysFeedsOverview.0, date: profile.parent.todaysFeedsOverview.2
            )
            
            DashboardHeaderOverviewItem(
                title: "Nappy Changes".localized,
                value: nappyChangesValue,
                count: profile.parent.todaysNappiesOverview.0,
                date: profile.parent.todaysNappiesOverview.3
            )
            
            DashboardHeaderOverviewItem(
                title: "Nap Times".localized,
                value: napsValue,
                count: profile.parent.todaysNapsOverview.0,
                date: profile.parent.todaysNapsOverview.2
            )
            
            Text("Manage Data")
                .foregroundColor(.gray).font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(y: -30)
    }
    
//    var bodys: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Text("Today".localized).font(.headline)
//
//                Spacer()
//                Text("Children and Data".localized)
//                    .font(.footnote)
//                    .foregroundColor(Color(UIColor.secondaryLabel))
//            }.padding([.leading, .top, .trailing]).padding(.bottom, 5)
//
//            Divider().opacity(0.5).offset(y: -10).padding([.leading, .trailing])
//
//            HStack(alignment: .top) {
//                VStack(alignment: .leading) {
//                    Text("Feeds".localized)
//                        .font(.subheadline).padding(.bottom, 10)
//
//                    Text(String.localizedStringWithFormat(NSLocalizedString("%ld tracked %@ today", comment: "todays feed counter"), "feed", profile.parent.todaysFeedsOverview.0 ?? 0))
//                        .font(.footnote).foregroundColor(Color(UIColor.secondaryLabel))
//                }
//                .frame(minWidth: 0, maxWidth: .infinity)
//
//                Divider().frame(height: 50)
//                Spacer()
//
//                VStack(alignment: .leading) {
//                    Text("Nappies".localized)
//                        .font(.subheadline).padding(.bottom, 10)
//
//                    Text(String.localizedStringWithFormat(NSLocalizedString("%ld and %ld nappies today", comment: "todays feed counter"), profile.parent.todaysNappiesOverview.1, 2, profile.parent.todaysNappiesOverview.2)).font(.footnote).foregroundColor(Color(UIColor.secondaryLabel))
//                }.frame(minWidth: 0, maxWidth: .infinity)
//
//                Divider().frame(height: 50)
//                Spacer()
//
//                VStack(alignment: .leading) {
//                    Text("Naps".localized)
//                        .font(.subheadline).padding(.bottom, 10)
//
//                    Text(String.localizedStringWithFormat(NSLocalizedString("%ld tracked %@ today", comment: "todays feed counter"), "feed", profile.parent.todaysNapsOverview.0))
//                        .font(.footnote).foregroundColor(Color(UIColor.secondaryLabel))
//                }.frame(minWidth: 0, maxWidth: .infinity)
//            }
//        }
//        .padding(.bottom, 10)
//        .frame(maxWidth: .infinity)
//        .background(Color(UIColor.secondarySystemBackground))
//        .cornerRadius(10)
//    }
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
