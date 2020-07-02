//
//  Child+FeedSessions.swift
//  bibs
//
//  Created by Paul Hendrick on 30/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

extension Child: Identifiable {
    public var wrappedCreatedAt: Date {
        get {createdAt ?? Date()}
        set {createdAt = newValue}
    }
    
    public var wrappedDueDate: Date {
        get {dueDate ?? Date()}
        set {dueDate = newValue}
    }
    
    public var wrappedImage: UIImage {
        get {UIImage()}
        set {image = (newValue.pngData()) }
    }
    
    public var wrappedName: String {
        get {name ?? ""}
        set {name = newValue}
    }
    
    public var feedSessionsArray: [FeedSession] {
        let set = feedSessions as? Set<FeedSession> ?? []
        return set.sorted {
            $0.wrappedCreatedAt > $1.wrappedCreatedAt
        }
    }
    
    public var nappyChangesArray: [NappyChange] {
        let set = nappyChanges as? Set<NappyChange> ?? []
        return set.sorted {
            $0.wrappedCreatedAt > $1.wrappedCreatedAt
        }
    }
    
    var activeFeedSession: FeedSession? {
        let request: NSFetchRequest<FeedSession> = FeedSession.fetchRequest()
        
        request.predicate = NSPredicate(format: "state == %@", NSNumber(value: FeedSession.FeedSessionStatus.running.rawValue))
        request.fetchLimit = 1
        
        guard let context = self.managedObjectContext else {
            print("Error!!")
            fatalError()
        }
        
        do {
            let sessions = try context.fetch(request) as [FeedSession]
            
            return sessions.first
        }catch {
            return nil
        }
    }
    
    func startNewFeedSession() throws {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        /// mark any old feed sessions as complete
        for activeSession in feedSessionsArray where activeSession.status != .complete {
            try? activeSession.finish()
        }
        
        let session       = FeedSession(context: context)
        session.createdAt = Date()
        session.status = .paused
        
        let feed       = Feed(context: context)
        feed.createdAt = Date()
        feed.breastSide = .left
        
        session.addToFeeds(feed)
        self.addToFeedSessions(session)
        
        do {
           try context.save()
            
            session.resume()
        }catch {
            print("Error: \(error)")
        }
    }
    
    func clear() {
        print("Clearing data for \(self.wrappedName) - \(self.feedSessionsArray.count)")
        
        if let moc = self.managedObjectContext {
            _ = self.feedSessionsArray.map { moc.delete($0) }

            try? moc.save()
        }
    }
    
}
