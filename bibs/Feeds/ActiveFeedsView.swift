//
//  ActiveFeedsView.swift
//  bibs
//
//  Created by Paul Hendrick on 24/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ActiveFeedsView: View {
    @Environment(\.managedObjectContext) var moc
//    @EnvironmentObject var activeFeedSessions: ActiveFeedSessions
//    @FetchRequest(entity: Child.entity(), sortDescriptors: []) var children: FetchedResults<Child>
    
//    @State var imagePickerIsVisible = false
//    @State var selectedImage = UIImage()
    
    var body: some View {
        VStack {
            Text("OK")
//            Text("\(children.count) children")
//
//            ForEach(children) { child in
//                Text("Child \(child.wrappedCreatedAt)")
//            }

//            if children.count > 1 {
//                Button(action: {
//                    let activeFeed = Feed()
//                    self.activeFeeds.addToActiveFeeds(feed: activeFeed)
//                }) {
//                    Text("Add Feed")
//                }
//            }else {
//                Divider()
//
//                Button(action: {
//                    self.addChild()
//                }) {
//                    Text("Add child")
//                }
//            }
        }
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
//            feed.duration  = 10 + Int16(arc4random_uniform(200))
//            feed.side      = Int16(arc4random_uniform(1))
//            feed.feedSession = session
//            session.addToFeeds(feed)
//        }
//        
//        var expression = Expression(context: moc)
//        expression.createdAt = Date()
//        expression.amount = 44.2
//        expression.side = 1
//        session.addToExpressions(expression)
//
//        for _ in 0...(1 + arc4random_uniform(20)) {
//            expression = Expression(context: moc)
//            expression.createdAt = Date()
//            expression.amount = 44.2
//            expression.side = 1
//            session.addToExpressions(expression)
//        }
//
//        child.addToFeedSessions(session)
//
//        print("Saving (activefeeds view)")
//        try? moc.save()
    }
}

//struct ActiveFeedsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        
//        return ActiveFeedsView()
//            .environmentObject(ActiveFeedSessions.shared)
//            .environment(\.managedObjectContext, context)
//    }
//}
