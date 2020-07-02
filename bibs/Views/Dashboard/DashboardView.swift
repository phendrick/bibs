//
//  DashboardView.swift
//  bibs
//
//  Created by Paul Hendrick on 25/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

enum FeedTool: Int, CaseIterable {
    case FeedTimer
    case NappyChange
    case ExpressedFeed
    case DataOverview
}

struct DashboardView: View {
    @State private var childSheetVisible: Bool = false
    
    @EnvironmentObject var activeChildProfile: ActiveChildProfile
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
    
    func childListActionSheetButtons(exclude: Child?) -> [ActionSheet.Button] {
        guard let activeChild = exclude else {
            return []
        }
        
        var buttons: [ActionSheet.Button] = []
        
        for child in children where child != activeChild {
            let button = ActionSheet.Button.default(Text("\(child.wrappedName)")) {
                self.activeChildProfile.setActiveChildProfile(child: child)
            }
            
            buttons.append(button)
        }
        
        buttons.append(.cancel())
        
        return buttons
    }
    
    func childListActionSheetMessage(current: String ) -> String {
        return "Active child profile: \(current)"
    }
    
    init() {
        UINavigationBar.appearance().backgroundColor = .red
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { outerGeometry in
                ScrollView(showsIndicators: false) {
                    VStack {
                        DashboardToolsView(
                            geometry: outerGeometry,
                            activeFeedTool: self.$activeFeedTool
                        )

                        ForEach(self.activeChildProfile.child?.feedSessionsArray ?? []) {session in
                            FeedSessionView(
                                cofeeding: false,
                                cofeedingIndex: 0,
                                feedSession: session
                            )
                        }
                        
                        ForEach(self.activeFeedSessions.indices) {feedSessionIndex in
                            FeedSessionView(
                                cofeeding: self.activeFeedSessions.count>1,
                                cofeedingIndex: feedSessionIndex,
                                feedSession: self.activeFeedSessions[feedSessionIndex]
                            )
                        }
                        
                        if self.cofeeding && self.activeFeedSessions.filter {$0.status == .running}.count == 2 {
                            Divider()
                            
                            Button(action: {
                                let _ = self.activeFeedSessions.map {$0.pause()}
                            }) {
                                Text("Pause all")
                            }
                        }
                        
                        if self.activeFeedTool == .FeedTimer {
                            DashboardDataView(
                                title: "Feeds",
                                predicate: NSPredicate(format: "state == %@", NSNumber(value: FeedSession.FeedSessionStatus.complete.rawValue)),
                                sortDescriptors: [NSSortDescriptor(key: "createdAt", ascending: false)]
                            ) { (result: FeedSession, index) in
                                HStack {
                                    Text(result.formattedElapsedTime(include_hsec: false))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Button(action: {
                                do {
                                    try self.activeChildProfile.child?.startNewFeedSession()
                                }catch {
                                }
                            }) {
                                HStack {
                                    Text("New session")
                                    Spacer()
                                }.padding()
                            }
                            
                            Button(action: {
                                self.activeChildProfile.child?.clear()
                            }) {
                                HStack {
                                    Text("Clear out")
                                    Spacer()
                                }.padding()
                            }
                        }

                        if self.activeFeedTool == .NappyChange {
                            DashboardDataView(title: "Nappy Changes") { (result: FeedSession, index) in
                                Text("\(result.status.rawValue)")
                            }
                        }

                        if self.activeFeedTool == .ExpressedFeed {
                            DashboardDataView(title: "Expressed Feed") { (result: FeedSession, index) in
                                Text("\(result.duration)")
                            }
                        }

                        Spacer()
                    }
                }
            }
            .navigationBarTitle("Morning, User", displayMode: .inline)
            .navigationBarItems(
                leading:  NavigationLink(destination: ProfileEditView()) {
                    Image(systemName: "person.crop.circle").foregroundColor(.red)
                },
                trailing: Image(systemName: "heart.circle.fill").foregroundColor(.red).onTapGesture {
                    self.showingChildListActionSheet = true
                }
            )
            .actionSheet(isPresented: self.$showingChildListActionSheet) {
                ActionSheet(
                    title: Text("Switch profile"),
                    message: Text("The current active profile is: \(self.activeChildProfile.child?.wrappedName ?? "")"),
                    buttons: self.childListActionSheetButtons(exclude: self.activeChildProfile.child)
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .scaleEffect(0.98)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return DashboardView()
            .environment(\.managedObjectContext, context)
            .environmentObject(ActiveChildProfile.shared)
    }
}
