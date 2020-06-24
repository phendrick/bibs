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
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Morning")
                        .font(.system(size: 44, weight: .bold))
                    Text("Let's get started...")
                        .font(.system(size: 14, weight: .regular))
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Text("feed")
                            .frame(
                                width: min(max(outerGeometry.size.width*0.33, 160), 160),
                                height: min(max(outerGeometry.size.width*0.33, 180), 180)
                            )
                            .background(Color.orange)
                            .onTapGesture {
                                self.activeFeedTool = .FeedTimer
                            }
                        
                        Text("nappy")
                            .frame(
                                width: min(max(outerGeometry.size.width*0.33, 160), 160),
                                height: min(max(outerGeometry.size.width*0.33, 180), 180)
                            )
                            .background(Color.red)
                            .onTapGesture {
                                self.activeFeedTool = .NappyChange
                            }
                        
                        Text("expressed")
                            .frame(
                                width: min(max(outerGeometry.size.width*0.33, 160), 160),
                                height: min(max(outerGeometry.size.width*0.33, 180), 180)
                            )
                            .background(Color.orange)
                            .onTapGesture {
                                self.activeFeedTool = .ExpressedFeed
                            }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color.yellow)
                
                Divider()
                
                VStack {
                    ForEach(0..<5) {idx in
                        DataRowView(index: idx)
                    }
                }
                
                Divider()
                
                Spacer()
                
                if self.activeFeedTool == .FeedTimer {
                    DashboardDataView<FeedSession>()
                }

                if self.activeFeedTool == .NappyChange {
                    DashboardDataView<Child>()
                }

                if self.activeFeedTool == .ExpressedFeed {
                    DashboardDataView<Feed>()
                }
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
