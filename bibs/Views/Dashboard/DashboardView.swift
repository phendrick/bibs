//
//  DataView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var profile: ProfileObserver
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @State var expanded: Bool = true
    @State var cofeeding: Bool = false
    
    @State var selectedEmotionType: Emotion.EmotionType?
    @State var parentTrackerFormVisible = false
    
    var count: CGFloat = 2
    
    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                NavigationView {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
//                            DashboardHeaderView()
//                                .padding()
//                                .offset(y: -10)
                            
                            NavigationLink(destination: DatapointsIndexListView(profile: self.profile)) {
                                DashboardHeaderOverviewView(profile: self.profile).padding()
                            }.foregroundColor(Color(UIColor.label))
                            
                            DashboardToolsListView().padding([.top, .bottom])
//                                .offset(y: -40)
                        }
                        .navigationBarTitle(Text(dashboardGreeting(for: self.profile.parent)), displayMode: .large)
                        .navigationBarItems(trailing: HStack {
                            Button("❤️") {
                                self.parentTrackerFormVisible = true
                            }
                        }).sheet(isPresented: self.$parentTrackerFormVisible) {
                            ParentTrackerFormSheet(
                                profile: self.profile,
                                parentTrackerFormVisible: self.$parentTrackerFormVisible,
                                selectedEmotionType: self.selectedEmotionType
                            )
                            .environment(\.managedObjectContext, self.moc)
                            .environmentObject(self.profile)
                        }
                    }
                }.padding([.top, .bottom], geometry.safeAreaInsets.top)
            }
            .padding(.bottom, self.profile.trayHeight)
            
            Spacer()
            
            if self.profile.parent.breastfeedingChildrenArray.count > 0 {
                ActiveFeedsTrayView(profile: self.profile)
                    .clipped()
                    .shadow(color: Color.gray.opacity(0.25), radius: 0, x: 0, y: -10)
            }
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(profile: ProfileObserver.shared)
//            .previewLayout(.fixed(width: 400, height: 800))
    }
}
