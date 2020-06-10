//
//  DashboardView.swift
//  bibs
//
//  Created by Paul Hendrick on 25/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Child.entity(), sortDescriptors: []) var children: FetchedResults<Child>
    @FetchRequest(
        entity: FeedSession.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "state == %@", NSNumber(value: FeedSession.FeedSessionStatus.running.rawValue)),
        animation: .spring()) var activeFeedSessions: FetchedResults<FeedSession>
    
    @State var showingChild: Bool = false
    @State var currentChild: Child?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    HStack(alignment: .top) {
                        VStack {
                            Text("Hello").font(.headline)
                            Text("World")
                                .font(.subheadline)
                                .padding([.top, .bottom])
                        }
                        
                        Spacer()
                        
                        VStack {
                            Image(systemName: "person.crop.circle.fill")
                        }
                    }
                }.padding()
                
                Divider()
                
                ScrollView(.horizontal) {
                    ForEach(children) {child in
                        NavigationLink(destination: ChildView().environmentObject(child)) {
                            VStack {
                                Text(child.wrappedName)
                            }
                        }.padding()
                        Text("OK").onTapGesture {
                            if let session = child.feedSessionsArray.first {
                                if session.status == .running {
                                    session.status = .paused
                                }else {
                                    session.status = .running
                                }
                                
                                try? self.moc.save()
                            }
                        }
                    }
                }
                
                ActiveFeedSessionsList()
                
                Spacer()
            }
            .navigationBarHidden(true)
            .navigationBarTitle("")
        }
        .onAppear {
            if let currentChildUrl = UserDefaults.standard.url(forKey: "currentChild") {
                let child = self.children.first { (child) -> Bool in
                    return child.objectID.uriRepresentation() == currentChildUrl
                }

                self.currentChild = child
            }

            guard let _ = self.currentChild else {
                if let firstChild = self.children.first {
                    self.currentChild = firstChild
                }

                return
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return DashboardView()
            .coordinateSpace(name: "Default")
            .environment(\.managedObjectContext, context)
    }
}
