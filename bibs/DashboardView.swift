//
//  DashboardView.swift
//  bibs
//
//  Created by Paul Hendrick on 25/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import Introspect
import CoreData

enum FeedTool: String, CaseIterable {
    case FeedTimer = "Feed Timer"
    case NappyChange = "Nappy Change"
    case ExpressedFeed = "Expressed Feed"
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
            format: "state == %@", NSNumber(
                value: FeedSession.FeedSessionStatus.running.rawValue
            )
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
                                .frame(width: outerGeometry.size.width * 0.5, height: outerGeometry.size.width*0.5)
                                .background(Color.orange)
                                .onTapGesture {
                                    self.activeFeedTool = .FeedTimer
                                }

                            Text("nappy")
                                .frame(width: outerGeometry.size.width * 0.5, height: outerGeometry.size.width*0.5)
                                .background(Color.red)
                                .onTapGesture {
                                    self.activeFeedTool = .NappyChange
                                }

                            Text("expressed")
                                .frame(width: outerGeometry.size.width * 0.5, height: outerGeometry.size.width*0.5)
                                .background(Color.orange)
                                .onTapGesture {
                                    self.activeFeedTool = .ExpressedFeed
                                }
                        }                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 1))

                    Divider()

                    if self.activeFeedTool == .FeedTimer {
                        DashboardDataView(title: "Feeds") { (result: FeedSession, index) in
                            Text(result.formattedElapsedTime())
                                .padding(.leading, 0)
                        }
                        
                        Button(action: {
                            print("Start new feed")
                        }) {
                            HStack {
                                Text("Start Timer")
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
