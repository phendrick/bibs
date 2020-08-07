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

                    if showChildList {
                        NavigationLink(destination: ChildrenDashboardListView(profile: self.profile)) {
                            DashboardHeaderOverviewView(profile: profile).padding()
                        }.foregroundColor(Color(UIColor.label))
                    }else if self.profile.parent.activeChild != nil {
                        NavigationLink(destination: DatapointsListView(child: self.profile.parent.activeChild!, profile: self.profile)) {
                            DashboardHeaderOverviewView(profile: profile).padding()
                        }.foregroundColor(Color(UIColor.label))
                    }

                    DashboardToolsListView().padding([.top, .bottom])
                    
                    Spacer()
                }
                .navigationBarTitle(Text("Hello"), displayMode: .large)
                .navigationBarItems(
                    leading:  NavigationLink(destination: ProfileEditView().environmentObject(self.profile)) {
                        Image(systemName: "person.crop.circle").foregroundColor(.red)
                    }
                )
            }
            
            Spacer()
            
            ActiveFeedsTrayView(profile: self.profile)
                .background(
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                        .clipped(antialiased: true)
                        .shadow(color: Color.gray.opacity(0.15), radius: 0, x: 0, y: -6)
                )
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
