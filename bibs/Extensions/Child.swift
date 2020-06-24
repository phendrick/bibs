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
        if let moc = self.managedObjectContext {
            for activeSession in feedSessionsArray where activeSession.status != .complete {
                activeSession.status = .complete
            }
            
            let session       = FeedSession(context: moc)
            session.createdAt = Date()
            
            let feed       = Feed(context: moc)
            feed.createdAt = Date()
            
            session.addToFeeds(feed)
            self.addToFeedSessions(session)
            
            do {
                try moc.save()
                
                self.objectWillChange.send()
            }catch {
            }
        }
    }
    
}