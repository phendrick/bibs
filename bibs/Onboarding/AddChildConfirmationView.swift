//
//  AddChildConfirmationView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct AddChildConfirmationView: View {
    @EnvironmentObject var viewSettings: ViewSettings
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            Text("There! That wasn't too bad.")
                .font(.headline)
            Text("Ready to get started?")
                .font(.footnote)
            Spacer()
            
            Button(action: {
                self.viewSettings.initialView = .dashboard
            }) {
                Text("Done")
            }
            
            Spacer()
            
            NavigationLink(destination: AddChildView()) {
                Text("Add your baby")
            }
            
        }.frame(maxWidth: .infinity)
    }
    
    func addChild() {
//        let names = ["Paul", "Lucy", "Milo", "Tabitha", "Gus", "Geoff"]
//        let child = Child(context: moc)
//        child.colorScheme = 1
//        child.createdAt = Date()
//        child.dueDate   = Date()
//        child.isBorn    = true
//        child.name      = names.randomElement()!
//        
//        let session = FeedSession(context: moc)
//        session.createdAt = Date()
//        
//        var feed = Feed(context: moc)
//        feed.createdAt = Date()
//        feed.duration  = 200
//        feed.side      = 0
//        feed.feedSession = session
//        session.addToFeeds(feed)
//        
//        for _ in 0...(1 + arc4random_uniform(40)) {
//            feed = Feed(context: moc)
//            feed.createdAt = Date()
//            feed.duration  = 10 + Int32(arc4random_uniform(200))
//            feed.side      = Int16(arc4random_uniform(1))
//            feed.feedSession = session
//            session.addToFeeds(feed)
//        }
//        
//        child.addToFeedSessions(session)
//        
//        print("add baby save")
//        try? moc.save()
    }
}

struct AddChildConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        AddChildConfirmationView()
    }
}
