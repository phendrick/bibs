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
    case NappyChange
    case ExpressedFeed
    case DataOverview
}

struct DashboardView: View {
    @State private var childSheetVisible: Bool = false
    
    @EnvironmentObject var profile: ProfileObserver
    @ObservedObject var viewSettings = ViewSettings()
    @Environment(\.managedObjectContext) var moc
    
    @State var page: Int = 0
    
    @FetchRequest(
        entity: FeedSession.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "state IN %@", [
            FeedSession.FeedSessionStatus.running.rawValue, FeedSession.FeedSessionStatus.paused.rawValue
        ]),
        animation: .spring()) var activeFeedSessions: FetchedResults<FeedSession>
    
    @FetchRequest(
        entity: FeedSession.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "state == %d", Int16(FeedSession.FeedSessionStatus.complete.rawValue)),
        animation: .spring()) var completedFeedSessions: FetchedResults<FeedSession>
    
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
    
    init() {
        UINavigationBar.appearance().backgroundColor = .red
    }
    
    var body: some View {
        NavigationView {
            GeometryReader {geometry in
                ScrollView(showsIndicators: false) {
                    VStack {
                        DashboardToolsView(
                            outerGeometry: geometry,
                            activeFeedTool: self.$activeFeedTool
                        ).environmentObject(ToolsData())
                        
                        ForEach(self.profile.parent.activeChild?.feedSessionsArray ?? []) {session in
                            FeedSessionView(
                                cofeeding: false,
                                cofeedingIndex: 0,
                                feedSession: session
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
                            ForEach(self.completedFeedSessions, id: \.self) {session in
                                Text("OK")
                            }
                            
                            Divider()
                            
                            HStack {
                                Button(action: {
                                    do {
                                        try self.profile.parent.activeChild?.startNewFeedSession()
                                    }catch {
                                    }
                                }) {
                                    HStack {
                                        Text("New session")
                                        Spacer()
                                    }.padding()
                                }
                                
                                Button(action: {
                                    self.profile.parent.activeChild?.clear()
                                }) {
                                    HStack {
                                        Text("Clear out")
                                        Spacer()
                                    }.padding()
                                }
                            }
                        }
                        
                        Spacer()
                    }
                }
                .navigationBarTitle("Morning, mum", displayMode: .inline)
                .navigationBarItems(
                    leading:  NavigationLink(destination: ProfileEditView().environmentObject(self.profile)) {
                        Image(systemName: "person.crop.circle").foregroundColor(.red)
                    },
                    trailing: Image(systemName: "heart.circle.fill").foregroundColor(.red).onTapGesture {
                        self.showingChildListActionSheet = true
                    }
                )
                .actionSheet(isPresented: self.$showingChildListActionSheet) {
                    ActionSheet(
                        title: Text("Switch profile"),
                        message: Text("The current active profile is: \(self.profile.parent.activeChild?.wrappedName ?? "")"),
                        buttons: self.childListActionSheetButtons(exclude: self.profile.parent.activeChild)
                    )
                }
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
            .environmentObject(ProfileObserver.shared)
    }
}
