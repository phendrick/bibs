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
    
    @State var activeFeedTool: FeedTool = .FeedTimer
    @State var showingFeedSession: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader { outerGeometry in
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(self.activeFeedSessions) {s in
                            Text("\(s.formattedElapsedTime())")
                                .onTapGesture {
                                    if s.status == .running {
                                        s.pause()
                                    }else {
                                        s.resume()
                                    }
                                }
                        }
                        DashboardToolsView(
                            geometry: outerGeometry,
                            activeFeedTool: self.$activeFeedTool
                        )

                        FeedSessionView().padding()
                        
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
                                print("Start new feed")
                                do {
                                    try self.activeChildProfile.child?.startNewFeedSession()
                                }catch {
                                }
                            }) {
                                HStack {
                                    Text("Start Timer")
                                    Spacer()
                                }.padding()
                            }
                            
                            Button(action: {
                                print("Clearing sdata")
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
            .navigationBarTitle("Morning")
            .navigationBarItems(
                leading:  Image(systemName: "person.crop.circle").foregroundColor(.gray),
                trailing: Image(systemName: "heart.circle.fill").foregroundColor(.gray)
            )
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
