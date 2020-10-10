//
//  DashboardHeaderView.swift
//  bibs
//
//  Created by Paul Hendrick on 24/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardHeaderView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(dashboardSubtitle(for: self.profile.parent)).font(.title)
                }
                
                Spacer()
                
                Text("\(self.profile.parent.latestEmotionType.emoji)").font(.system(size: 32))
            }
        }
    }
}

struct DashboardHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardHeaderView()
            //.previewLayout(.fixed(width: 360, height: 300))
    }
}
