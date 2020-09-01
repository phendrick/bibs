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
                    
                    NavigationLink(destination: DatapointsIndexListView(profile: self.profile)) {
                        DashboardHeaderOverviewView(profile: profile).padding()
                    }.foregroundColor(Color(UIColor.label))
                    
                    HStack(spacing: 20) {
                        Button("Add Data") {
                            guard var startDate = Calendar.current.date(byAdding: .month, value: -10, to: Date()) else {
                                return
                            }
                            guard let child = self.profile.parent.childrenArray.first else {
                                print("no child to add data to")
                                return
                            }
                            
                            print("Starting at date \(startDate)")
                            
                            repeat {
                                for _ in 5...Int.random(in: 10...15) {
                                    let feedSession = FeedSession(context: self.moc)
                                    let feed = Feed(context: self.moc)
                                    feedSession.addToFeeds(feed)
                                    feedSession.createdAt = startDate
                                    feedSession.status = .complete
                                    feed.createdAt = startDate
                                    feed.duration = Int32.random(in: 1000...303030)
                                    feed.breastSide = Feed.BreastSide.allCases.randomElement()!
                                    child.addToFeedSessions(feedSession)
                                    
                                    let bottleFeed = BottleFeed(context: self.moc)
                                    bottleFeed.createdAt = startDate
                                    bottleFeed.amount = Int16.random(in: 10...40)
                                    child.addToBottleFeeds(bottleFeed)
                                    
                                    let nappyChange = NappyChange(context: self.moc)
                                    nappyChange.createdAt = startDate
                                    nappyChange.status = NappyChange.NappyChangeType.allCases.randomElement()!
                                    
                                    if nappyChange.status == .dirty {
                                        nappyChange.poopColor = NappyChange.NappyChangePoopColor.allCases.randomElement()!
                                    }
                                    
                                    child.addToNappyChanges(nappyChange)
                                }
                                
                                startDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate)!
                            }while(startDate.beginningOfDay < Date().endOfDay)
                            
                            print("Done at date \(startDate)")
                            try? self.moc.save()
                        }
                        
                        Button("Clear Data") {
                            guard let child = self.profile.parent.childrenArray.first else {
                                print("no child to add data to")
                                return
                            }
                            
                            child.bottleFeedsArray.forEach { self.moc.delete($0) }
                            child.nappyChangesArray.forEach { self.moc.delete($0) }
                            child.feedSessionsArray.forEach { self.moc.delete($0) }
                            
                            try? self.moc.save()
                        }
                        
                        Button("Profile") {
                            self.profile.objectWillChange.send()
                        }
                        
                        Button("Add timer") {
                            guard let child = self.profile.parent.childrenArray.first else {
                                print("no child to add data to")
                                return
                            }
                            
                            if let activeSession = child.activeFeedSession {
                                print("Completing previous timer")
                                activeSession.complete()
                            }
                            
                            self.profile.objectWillChange.send()
                            try? child.startNewFeedSession()
                        }
                    }
                    
                    DashboardToolsListView().padding([.top, .bottom])
                    
                    Spacer()
                }
                .navigationBarTitle(Text(""), displayMode: .inline)
                .offset(y: -20)
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
