//
//  AddBabyConfirmationView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct AddBabyConfirmationView: View {
    @EnvironmentObject var viewSettings: ViewSettings
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            Text("Welcome to the app")
            
            Button(action: {
                self.addChild()
                withAnimation {
                    self.viewSettings.initialView = .dashboard
                }
            }) {
                Text("Add Baby")
            }
        }.navigationBarTitle("Test")
    }
    
    func addChild() {
        let names = ["Paul", "Lucy", "Milo", "Tabitha", "Gus", "Geoff"]
        let child = Child(context: moc)
        child.colorScheme = 1
        child.createdAt = Date()
        child.dueDate   = Date()
        child.isBorn    = true
        child.name      = names.randomElement()!
        
        let session = FeedSession(context: moc)
        session.createdAt = Date()
        
        var feed = Feed(context: moc)
        feed.createdAt = Date()
        feed.duration  = 200
        feed.side      = 0
        feed.feedSession = session
        session.addToFeeds(feed)
        
        for _ in 0...(1 + arc4random_uniform(40)) {
            feed = Feed(context: moc)
            feed.createdAt = Date()
            feed.duration  = 10 + Int16(arc4random_uniform(200))
            feed.side      = Int16(arc4random_uniform(1))
            feed.feedSession = session
            session.addToFeeds(feed)
        }
        
        var expression = Expression(context: moc)
        expression.createdAt = Date()
        expression.amount = 44.2
        expression.side = 1
        session.addToExpressions(expression)
        
        for _ in 0...(1 + arc4random_uniform(20)) {
            expression = Expression(context: moc)
            expression.createdAt = Date()
            expression.amount = 44.2
            expression.side = 1
            session.addToExpressions(expression)
        }

        child.addToFeedSessions(session)
        
        try? moc.save()
    }
}

struct AddBabyConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        AddBabyConfirmationView()
    }
}
