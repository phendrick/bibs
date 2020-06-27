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
        predicate: NSPredicate(
            format: "state != %@", NSNumber(value: FeedSession.FeedSessionStatus.complete.rawValue)
        ),
        animation: .spring()) var activeFeedSessions: FetchedResults<FeedSession>
    
    @State var activeFeedTool: FeedTool = .FeedTimer
    
    var body: some View {
        GeometryReader {outerGeometry in
            NavigationView {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            Text("feed")
                                .frame(width: outerGeometry.size.width*0.6, height: outerGeometry.size.width*0.5)
                                .background(Color.orange)
                                .padding(.leading, 80)
                                .onTapGesture {
                                    self.activeFeedTool = .FeedTimer
                                }

                            Text("nappy")
                                .frame(width: outerGeometry.size.width*0.6, height: outerGeometry.size.width*0.5)
                                .background(Color.red)
                                .padding(.leading, 80)
                                .onTapGesture {
                                    self.activeFeedTool = .NappyChange
                                }

                            Text("expressed")
                                .frame(width: outerGeometry.size.width*0.6, height: outerGeometry.size.width*0.5)
                                .background(Color.orange)
                                .padding([.leading, .trailing], 80)
                                .onTapGesture {
                                    self.activeFeedTool = .ExpressedFeed
                                }
                            
                            Text("data")
                            .frame(width: outerGeometry.size.width*0.6, height: outerGeometry.size.width*0.5)
                            .background(Color.orange)
                            .padding([.leading, .trailing], 80)
                            .onTapGesture {
                                self.activeFeedTool = .DataOverview
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 1))

                    ForEach(self.activeFeedSessions) {feedSession in
                        HStack {
                            FeedSessionView().environmentObject(feedSession)
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
                            do {
                                try self.activeChildProfile.child?.clear()
                            }catch {
                            }
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
                .navigationBarTitle("Morning")
                .navigationBarItems(
                    leading:  Image(systemName: "person.crop.circle").foregroundColor(.orange),
                    trailing: Image("heart").resizable().frame(width: 40, height: 40)
                )
            }
        }
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
