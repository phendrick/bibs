//
//  DashboardToolsView.swift
//  bibs
//
//  Created by Paul Hendrick on 24/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardToolsListItem: View {
    var icon: String
    var label: String
    
    var iconSize: CGFloat {
        UIDevice.current.hasLargeScreen ? 100 : 80
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Image(icon).resizable().frame(width: self.iconSize, height: self.iconSize)
            
            Text(label.localized)
                .font(.caption)
                .multilineTextAlignment(.center)
                .layoutPriority(2)
        }
        .frame(maxWidth: .infinity)
    }
}

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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("add_data".localized).font(.headline)
                .padding([.leading, .trailing])
                .offset(y: 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 15) {
                    DashboardToolsListItem(icon: "bottle", label: "stored_milk".localized)
                        .onTapGesture {
                            self.expressedMilkFormVisible = true
                        }.sheet(isPresented: self.$expressedMilkFormVisible) {
                            ExpressedMilkFormSheet(expressedMilkFormVisible: self.$expressedMilkFormVisible)
                                .environment(\.managedObjectContext, self.moc)
                                .environmentObject(self.profile)
                        }
                    
                    DashboardToolsListItem(icon: "bottle", label: "bottle_feed".localized)
                        .onTapGesture {
                            self.bottleFeedFormVisible = true
                        }.sheet(isPresented: self.$bottleFeedFormVisible) {
                            BottleFeedsFormSheet(bottleFeedFormVisible: self.$bottleFeedFormVisible)
                                .environment(\.managedObjectContext, self.moc)
                                .environmentObject(self.profile)
                        }
                    
                    DashboardToolsListItem(icon: "bottle", label: "breastfeed".localized)
                        .onTapGesture {
                            self.manualFeedTimerFormVisible = true
                        }.sheet(isPresented: self.$manualFeedTimerFormVisible) {
                            ManualFeedTimerEntryFormSheet(feedTimerFormVisible: self.$manualFeedTimerFormVisible)
                                .environment(\.managedObjectContext, self.moc)
                                .environmentObject(self.profile)
                        }
                        
                    DashboardToolsListItem(icon: "nappy", label: "nappies".localized)
                        .onTapGesture {
                            self.nappyChangeFormVisible = true
                        }.sheet(isPresented: self.$nappyChangeFormVisible) {
                            NappyChangeFormSheet(nappyChangeFormVisible: self.$nappyChangeFormVisible)
                                .environment(\.managedObjectContext, self.moc)
                                .environmentObject(self.profile)
                        }
                    
                    DashboardToolsListItem(icon: "mummy", label: "weaning".localized)
                        .onTapGesture {
                            self.snackFormVisible = true
                        }.sheet(isPresented: self.$snackFormVisible) {
                            SnackFormSheet(snackFormVisible: self.$snackFormVisible)
                                .environment(\.managedObjectContext, self.moc)
                                .environmentObject(self.profile)
                        }
                        
                    DashboardToolsListItem(icon: "mummy", label: "nap_time".localized)
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
