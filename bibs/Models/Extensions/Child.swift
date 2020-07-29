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
import UIKit

typealias ChildTheme = (Color, Color, Color)

extension Child: Identifiable, Trackable {
    public var title: String {
        "Baby name"
    }
    
    public var details: String {
        "baby details"
    }
    
    static let ColorSchemes: [Color] = [
        Color(#colorLiteral(red: 0.9753738046, green: 0.9755367637, blue: 0.9753522277, alpha: 1)),
        Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)),
        Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)),
        Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)),
        Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)),
        Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)),
        Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
    ]
    
    var themeColor: Color {
        let defaultColor = UIColor.white
        var color: UIColor?
        
        switch(self.colorScheme) {
        case 0:
            color = UIColor(named: "HighlightSilver")
        case 1:
            color = UIColor(named: "HighlightYellow")
        case 2:
            color = UIColor(named: "HighlightGreen")
        case 3:
            color = UIColor(named: "HighlightRed")
        case 4:
            color = UIColor(named: "HighlightPink")
        case 5:
            color = UIColor(named: "HighlightBlue")
        case 6:
            color = UIColor(named: "HighlightPurple")
        case 7:
            color = UIColor(named: "HighlightYellow")
        default:
            color = UIColor.white
        }
        
        let baseColor = color ?? defaultColor
        return Color(baseColor)
    }
    
    public enum ChildStatuses: Int16 {
        case current
        case archived
    }
    
    public var status: ChildStatuses {
        get {
            ChildStatuses.init(rawValue: self.state) ?? .current
        }
        
        set(newValue) {
            self.state = newValue.rawValue
        }
    }
    
    public var wrappedCreatedAt: Date {
        get {createdAt ?? Date()}
        set {createdAt = newValue}
    }
    
    public var wrappedDueDate: Date {
        get {dueDate ?? Date()}
        set {dueDate = newValue}
    }
    
    public var wrappedImage: UIImage {
        get {
            if let imageData = image {
                return UIImage(data: imageData) ?? UIImage()
            }else {
                return UIImage()
            }
        }
        
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
    
    public var latestFeedSessionsArray: [FeedSession] {
        let feedSessions = feedSessionsArray
        
        return Array(feedSessions.prefix(5))
    }
    
    public var completedFeedSessionsArray: [FeedSession] {
        let feedSessions = feedSessionsArray.filter {$0.status == .complete}
        
        return Array(feedSessions.prefix(5))
    }
    
    public var nappyChangesArray: [NappyChange] {
        let set = nappyChanges as? Set<NappyChange> ?? []
        return set.sorted {
            $0.wrappedCreatedAt > $1.wrappedCreatedAt
        }
    }
    
    public var napsArray: [Nap] {
        let set = naps as? Set<Nap> ?? []
        return set.sorted {
            $0.wrappedCreatedAt > $1.wrappedCreatedAt
        }
    }
    
    var activeFeedSession: FeedSession? {
        let request: NSFetchRequest<FeedSession> = FeedSession.fetchRequest()
        
        let activeSessionValues = [
            NSNumber(value: FeedSession.FeedSessionStatus.running.rawValue),
            NSNumber(value: FeedSession.FeedSessionStatus.paused.rawValue),
        ]
        
        request.predicate = NSPredicate(format: "state IN %@", activeSessionValues)
        request.fetchLimit = 1
        
        guard let context = self.managedObjectContext else {
            print("Error!!")
            fatalError()
        }
        
        self.parent?.objectWillChange.send()
        
        let sessions = try? context.fetch(request) as [FeedSession]
        
        if let session = sessions?.first {
            return session
        }else {
            return nil
        }
    }
    
    func buildNewFeedSession() -> FeedSession {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        let session       = FeedSession(context: context)
        session.createdAt = Date()
        session.status = .paused
        
        let feed       = Feed(context: context)
        feed.createdAt = Date()
        feed.breastSide = .left
        
        session.addToFeeds(feed)
        
        self.addToFeedSessions(session)
        
        return session
    }
    
    func startNewFeedSession() throws {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        /// mark any old feed sessions as complete
        for activeSession in feedSessionsArray where activeSession.status != .complete {
            try? activeSession.finish()
        }
        
        print("Starting new feed session")
        
        let session = self.buildNewFeedSession()
        
        do {
            try context.save()
            
            /// if the user has set their autostartTimers setting to true, `resume` it immediately
            if UserDefaults.standard.bool(forKey: "autostartTimers") {
                print("GO")
                session.resume()
            }
            
            print("done")
            self.objectWillChange.send()
        }catch {
            print("Error: \(error)")
        }
    }
    
    public var bottleFeedsArray: [BottleFeed] {
        let set = bottleFeeds as? Set<BottleFeed> ?? []
        return set.sorted {$0.wrappedCreatedAt < $1.wrappedCreatedAt}
    }
    
    func clear() {
        guard let context = self.managedObjectContext else {
            return
        }
        
        _ = self.feedSessionsArray.map { context.delete($0) }

        do {
            try context.save()
        }catch {
            print("Error saving context: ", error)
        }
    }
}
