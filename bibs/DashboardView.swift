//
//  DashboardView.swift
//  bibs
//
//  Created by Paul Hendrick on 25/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
    @FetchRequest(entity: Child.entity(), sortDescriptors: []) var children: FetchedResults<Child>
    @EnvironmentObject var activeFeedSessions: ActiveFeedSessions
    
    @State var currentChild: Child?
    
    var body: some View {
        VStack {
            ForEach(children) {child in
                Text("CHILD: \(child.wrappedName)")
            }

            ForEach(activeFeedSessions.feedSessions) {session in
                FeedSessionView(feedSession: session)
            }

            Spacer()

            currentChild.map { child in
                Text(child.wrappedName)
                    .background(Color.red)
            }
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
            .environmentObject(ActiveFeedSessions.shared)
            .environment(\.managedObjectContext, context)
    }
}
