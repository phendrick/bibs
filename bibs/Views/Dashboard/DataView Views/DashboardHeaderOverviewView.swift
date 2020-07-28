//
//  DashboardHeaderOverviewView.swift
//  bibs
//
//  Created by Paul Hendrick on 24/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardHeaderOverviewView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Today").font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color.gray)
            }
            .padding([.top, .leading, .trailing], 15)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("12 feeds").font(.subheadline).padding(.bottom, 10).lineLimit(1)
                    Text("1 hour 32 minutes")
                        .font(.footnote).foregroundColor(Color(UIColor.secondaryLabel))
                        .lineLimit(1).minimumScaleFactor(0.5)
                }.frame(minWidth: 0, maxWidth: .infinity)
                
                Divider().frame(height: 50)
                
                VStack(alignment: .leading) {
                    Text("8 changes").font(.subheadline).padding(.bottom, 10).lineLimit(1).lineLimit(1)
                    Text("3 dirty and 5 wet")
                        .font(.footnote).foregroundColor(Color(UIColor.secondaryLabel))
                        .lineLimit(1).minimumScaleFactor(0.5)
                }.frame(minWidth: 0, maxWidth: .infinity)
                
                Divider().frame(height: 50)
                
                VStack(alignment: .leading) {
                    Text("2 naps").font(.subheadline).padding(.bottom, 10).lineLimit(1)
                    Text("1 hour 32 minutes")
                        .font(.footnote).foregroundColor(Color(UIColor.secondaryLabel))
                        .lineLimit(1).minimumScaleFactor(0.5)
                }.frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding([.leading, .trailing])
            .padding(.bottom, 10)
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}

struct DashboardHeaderOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardHeaderOverviewView()
                .previewLayout(.fixed(width: 400, height: 180))
            
            DashboardHeaderOverviewView()
                .previewLayout(.fixed(width: 400, height: 240))
        }
    }
}
