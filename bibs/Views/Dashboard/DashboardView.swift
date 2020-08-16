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
    @State var timersListVisible: Bool = false
    
    var count: CGFloat = 2
    
    func widthFromGeometry(geometry: GeometryProxy) -> CGFloat {
        let multipler:CGFloat = count > 1 ? 0.9 : 1.0
        return geometry.frame(in: .global).width * multipler
    }
    
    var showChildList: Bool {
        self.profile.parent.activeChildrenArray.count > 1
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationView {
                VStack(spacing: 0) {
                    DashboardHeaderView().padding()

                    NavigationLink(destination: DatapointsIndexListView(profile: self.profile)) {
                        DashboardHeaderOverviewView(profile: profile).padding()
                    }.foregroundColor(Color(UIColor.label))
                    
                    DashboardToolsListView().padding([.top, .bottom])
                    
                    Spacer()
                }
                .navigationBarTitle(Text(""), displayMode: .inline)
                .offset(y: -20)
//                .navigationBarTitle(Text(dashboardGreeting(for: self.profile.parent)), displayMode: .large)
//                .navigationBarItems(
//                    leading:  NavigationLink(destination: ProfileEditView().environmentObject(self.profile)) {
//                        Image(systemName: "person.crop.circle").foregroundColor(.red)
//                    }
//                )
            }
            
            Spacer()
            
            ActiveFeedsTrayView(profile: self.profile)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .edgesIgnoringSafeArea(.all)
        .padding(.top, 2)
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(profile: ProfileObserver.shared)
//            .previewLayout(.fixed(width: 400, height: 800))
    }
}
