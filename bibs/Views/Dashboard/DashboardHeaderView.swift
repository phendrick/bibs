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
    
    @State var parentTrackerFormVisible = false
    @State var selectedEmotionType: Emotion.EmotionType?
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                Text("How are you today?")
                    .font(.title)
                
                Spacer()
                
                Text("\(self.profile.parent.latestEmotionType.emoji)")
                    .font(.system(size: 50))
            }.onTapGesture {
                self.parentTrackerFormVisible = true
            }.sheet(isPresented: self.$parentTrackerFormVisible) {
                ParentTrackerFormSheet(
                    profile: self.profile,
                    parentTrackerFormVisible: self.$parentTrackerFormVisible,
                    selectedEmotionType: self.selectedEmotionType
                )
                .environment(\.managedObjectContext, self.moc)
                .environmentObject(self.profile)
            }
        }.onAppear {
            print(self.profile.parent.latestEmotionType)
            self.selectedEmotionType = self.profile.parent.latestEmotionType
        }
    }
}

struct DashboardHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardHeaderView()
            //.previewLayout(.fixed(width: 360, height: 300))
    }
}
