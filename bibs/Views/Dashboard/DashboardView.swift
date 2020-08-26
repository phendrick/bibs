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
    
//    init(profile: ProfileObserver) {
    
    
//    https://filipmolcik.com/navigationview-dynamic-background-color-in-swiftui/
//        let standard = UINavigationBarAppearance()
//        let navigationBar = UINavigationBar.appearance()
//
//        standard.backgroundColor = UIColor(named: "HighlightYellow")! //When you scroll or you have title (small one)
//        standard.shadowColor = UIColor(named: "HighlightYellow")!
//        standard.shadowImage = nil
//
//        let compact = UINavigationBarAppearance()
//        compact.backgroundColor = UIColor(named: "HighlightYellow")! //compact-height
//        compact.shadowColor = UIColor(named: "HighlightYellow")!
//        compact.shadowImage = nil
//
//        let scrollEdge = UINavigationBarAppearance()
//        scrollEdge.backgroundColor = UIColor(named: "HighlightYellow")! //When you have large title
//        scrollEdge.shadowColor = UIColor(named: "HighlightYellow")!
//        scrollEdge.shadowImage = nil
//
//        navigationBar.standardAppearance = standard
//        navigationBar.compactAppearance = compact
//        navigationBar.scrollEdgeAppearance = scrollEdge
//
//        self.profile = profile
//    }
    
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
                        //.background(Color(UIColor(named: "HighlightYellow")!)).foregroundColor(.white)
                    
//                    Text("DATA").onTapGesture {
//                        let dailyReport = FeedSessionChartData(child: self.profile.parent.activeChild!).feedSessionDataInRange(range: .today)
//
//                        print(dailyReport)
////                        print(dailyReport.dailyOv
//
//                        print(FeedSessionChartData(child: self.profile.parent.activeChild!).feedSessionDataInRange(range: .today).data.keys)
//                        print("\n\n\n\n")
//
//                        print(FeedSessionChartData(child: self.profile.parent.activeChild!).feedSessionDataInRange(range: .todayAndMostRecentDay, includeAllDatesInRange: false).data.keys)
//                        print("\n\n\n\n")
//
//                        print(FeedSessionChartData(child: self.profile.parent.activeChild!).feedSessionDataInRange(range: .lastSevenDays).data.keys)
//                        print("\n\n\n\n")
//
//                        print(FeedSessionChartData(child: self.profile.parent.activeChild!).feedSessionDataInRange(range: .thisMonth).data.keys)
//                    }
                    
                    NavigationLink(destination: DatapointsIndexListView(profile: self.profile)) {
                        DashboardHeaderOverviewView(profile: profile).padding()
                            //.background(Color(UIColor(named: "HighlightYellow")!)).foregroundColor(.white)
                    }.foregroundColor(Color(UIColor.label))
                    
                    DashboardToolsListView().padding([.top, .bottom])
                        //.background(Color(UIColor(named: "HighlightYellow")!)).foregroundColor(.white)
                    
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
                //.background(Color(UIColor(named: "HighlightYellow")!)).foregroundColor(.white)
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
