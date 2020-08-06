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
    @State var emotionFormVisible = false
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                Text("How are you today?")
                    .font(.title)
                
                Spacer()
                
                Text("\(self.profile.parent.latestEmotionType.emoji)")
                    .font(.system(size: 50))
            }.onTapGesture {
                self.emotionFormVisible = true
            }.sheet(isPresented: self.$emotionFormVisible) {
                EmotionDiaryFormSheet(emotionDiaryFormVisible: self.$emotionFormVisible)
                    .environment(\.managedObjectContext, self.moc)
                    .environmentObject(self.profile)
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
