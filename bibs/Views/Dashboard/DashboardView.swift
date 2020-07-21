//
//  DashboardView.swift
//  bibs
//
//  Created by Paul Hendrick on 25/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData
import SwiftUIPager

enum FeedTool: Int, CaseIterable {
    case FeedTimer
    case BottleFeed
    case NappyChange
    case DataOverview
    
    var navigationBarTitle: String {
        switch(self) {
        case .FeedTimer: return "Timers"
        case .BottleFeed: return "Bottle Feeds"
        case .NappyChange: return "Nappy Changes"
        case .DataOverview: return "Data & Tracking"
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject var profile: ProfileObserver
    @ObservedObject var viewSettings = ViewSettings()
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        entity: FeedSession.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "state IN %@", [
            FeedSession.FeedSessionStatus.running.rawValue, FeedSession.FeedSessionStatus.paused.rawValue
        ]),
        animation: .spring()) var activeFeedSessions: FetchedResults<FeedSession>
    
    @FetchRequest(
        entity: Child.entity(),
        sortDescriptors: [],
        animation: .spring()) var children: FetchedResults<Child>
    
    @State var activeFeedTool: FeedTool = .FeedTimer
    @State var showingChildListActionSheet: Bool = false
    
    var cofeeding: Bool {
        self.activeFeedSessions.count > 1
    }
    
    var body: some View {
        NavigationView {
            GeometryReader {geometry in
                ZStack(alignment: .top) {
                    ActiveFeedsPreview(profile: self.profile)
                        .offset(
                            y: (self.activeFeedTool != .FeedTimer && self.profile.parent.currentFeedSessions.count > 0)
                                ? 0
                                : -geometry.frame(in: .global).minY*2
                        )
                        .zIndex(2)
                    
                    ScrollView(showsIndicators: false) {
                        VStack {
                            DashboardToolsView(
                                outerGeometry: geometry,
                                activeFeedTool: self.$activeFeedTool
                            ).environmentObject(ToolsData())
                            
                            /*
                             VStack {
                                 ForEach(profile.parent.currentFeedSessions, id: \.self) { session in
                                     HStack {
                                         Spacer()

                                         FeedSessionTimerView(
                                             feedSession: session
                                         )

                                         Spacer()

                                         FeedSessionTimerActions(feedSession: session)
                                     }
                                     .font(.custom("RobotoMono-Regular", size: 20))
                                     .padding()
                                     .background(
                                         RoundedRectangle(cornerRadius: 10, style: .continuous)
                                             .foregroundColor(session.child?.themeColor ?? .clear)
                                             .shadow(color: Color.gray.opacity(0.2), radius: 0, x: 0, y: 6)
                                     ).foregroundColor(.white)
                                 }
                             }
                             */
                            
                            if self.activeFeedTool.rawValue == 0 {
                                VStack(spacing: 5) {
                                    ForEach(self.profile.parent.currentFeedSessions) {session in
                                        HStack {
                                            FeedSessionTimerView(feedSession: session)
                                            FeedSessionTimerActions(feedSession: session)
                                        }
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 10, style: .circular)
                                                .foregroundColor(session.child?.themeColor ?? .green)
                                                .opacity(session.isActiveFeedSession ? 1 : 0.25)
                                        )
                                        .foregroundColor(.white)
                                        
                                    }
                                }.frame(maxWidth: geometry.size.width * 0.8)
                            }

                            if self.cofeeding && self.activeFeedSessions.filter {$0.status == .running}.count == 2 {
                                Button(action: {
                                    let _ = self.activeFeedSessions.map {$0.pause()}
                                }) {
                                    Text("Pause all")
                                }
                            }

                            if self.activeFeedTool == .FeedTimer {
                                FeedSessionActionsView()
                            }else if self.activeFeedTool == .BottleFeed {
                                BottleFeedActionsView()
                            }else if self.activeFeedTool == .NappyChange {
                                NappyChangeActionsView()
                            }else if self.activeFeedTool == .DataOverview {
                                DataToolsView()
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle(self.activeFeedTool.navigationBarTitle)
            .navigationBarItems(
                leading:  NavigationLink(destination: ProfileEditView().environmentObject(self.profile)) {
                    Image(systemName: "person.crop.circle").foregroundColor(.red)
                },
                trailing:
                    ZStack {
                        Image(systemName: "heart.circle.fill").foregroundColor(.red)
                            .onTapGesture {
                                self.showingChildListActionSheet = true
                        }
                    }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            print("Amount: ", self.profile.parent.expressedMilkAmount)
            print("Amount: ", self.profile.parent.expressedMilkGiven)
        }
    }
    
    func childListActionSheetButtons(exclude: Child?) -> [ActionSheet.Button] {
        guard let activeChild = exclude else {
            return []
        }
        
        var buttons: [ActionSheet.Button] = []
        
        for child in children where child != activeChild {
            let button = ActionSheet.Button.default(Text("\(child.wrappedName)")) {
                self.profile.parent.setActiveChild(child: child)
            }
            
            buttons.append(button)
        }
        
        buttons.append(.cancel())
        
        return buttons
    }

    func childListActionSheetMessage(current: String ) -> String {
        return "Active child profile: \(current)"
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return DashboardView()
            .environment(\.managedObjectContext, context)
            .environmentObject(ProfileObserver.shared)
    }
}
