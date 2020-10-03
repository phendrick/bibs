//
//  DashboardToolsView.swift
//  bibs
//
//  Created by Paul Hendrick on 24/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardToolsListView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    // action sheet states
    @State var nappyChangeFormVisible = false
    @State var bottleFeedFormVisible = false
    @State var snackFormVisible = false
    @State var naptimeFormVisible = false
    @State var expressedMilkFormVisible = false
    @State var manualFeedTimerFormVisible = false
    
    @State var foodDiaryFormVisible = false
    
    var iconSize: CGFloat {
        UIDevice.current.hasLargeScreen ? 100 : 80
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 15) {
                    VStack(alignment: .center) {
                        Image("bottle").resizable().frame(width: self.iconSize, height: self.iconSize)
                        Text("Stored Milk".localized)
                            .font(.subheadline).multilineTextAlignment(.center).layoutPriority(2)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        self.expressedMilkFormVisible = true
                    }.sheet(isPresented: self.$expressedMilkFormVisible) {
                        ExpressedMilkFormSheet(expressedMilkFormVisible: self.$expressedMilkFormVisible)
                            .environment(\.managedObjectContext, self.moc)
                            .environmentObject(self.profile)
                    }
                    
                    VStack(alignment: .center) {
                        Image("bottle").resizable().frame(width: self.iconSize, height: self.iconSize)
                        Text("Bottle Feed".localized)
                            .font(.subheadline).multilineTextAlignment(.center).layoutPriority(2)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        self.bottleFeedFormVisible = true
                    }.sheet(isPresented: self.$bottleFeedFormVisible) {
                        BottleFeedsFormSheet(bottleFeedFormVisible: self.$bottleFeedFormVisible)
                            .environment(\.managedObjectContext, self.moc)
                            .environmentObject(self.profile)
                    }
                    
                    VStack(alignment: .center) {
                        Image("bottle").resizable().frame(width: self.iconSize, height: self.iconSize)
                        Text("Breastfeed".localized)
                            .font(.subheadline).multilineTextAlignment(.center).layoutPriority(2)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        self.manualFeedTimerFormVisible = true
                    }.sheet(isPresented: self.$manualFeedTimerFormVisible) {
                        ManualFeedTimerEntryFormSheet(feedTimerFormVisible: self.$manualFeedTimerFormVisible)
                            .environment(\.managedObjectContext, self.moc)
                            .environmentObject(self.profile)
                    }
                    
                    VStack(alignment: .center) {
                        Image("nappy").resizable().frame(width: self.iconSize, height: self.iconSize)
                        Text("Nappy Change".localized).font(.subheadline).multilineTextAlignment(.center).layoutPriority(2)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        self.nappyChangeFormVisible = true
                    }.sheet(isPresented: self.$nappyChangeFormVisible) {
                        NappyChangeFormSheet(nappyChangeFormVisible: self.$nappyChangeFormVisible)
                            .environment(\.managedObjectContext, self.moc)
                            .environmentObject(self.profile)
                    }
                    
                    VStack(alignment: .center) {
                        Image("mummy").resizable().frame(width: self.iconSize, height: self.iconSize)
                        Text("Weaning".localized)
                            .font(.subheadline).multilineTextAlignment(.center).layoutPriority(2)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        self.snackFormVisible = true
                    }.sheet(isPresented: self.$snackFormVisible) {
                        SnackFormSheet(snackFormVisible: self.$snackFormVisible)
                            .environment(\.managedObjectContext, self.moc)
                            .environmentObject(self.profile)
                    }
                    
                    VStack(alignment: .center) {
                        Image("mummy").resizable().frame(width: self.iconSize, height: self.iconSize)
                        Text("Nap Time".localized)
                            .font(.subheadline).multilineTextAlignment(.center).layoutPriority(2)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        self.naptimeFormVisible = true
                    }.sheet(isPresented: self.$naptimeFormVisible) {
                        NaptimeFormSheet(naptimeFormVisible: self.$naptimeFormVisible)
                            .environment(\.managedObjectContext, self.moc)
                            .environmentObject(self.profile)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing], 15)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct DashboardToolsListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardToolsListView()
                .previewLayout(.fixed(width: 360, height: 220))
            
            DashboardToolsListView()
        }
    }
}
