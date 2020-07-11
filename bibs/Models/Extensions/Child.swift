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

extension Child: Identifiable {    
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
    
    enum ChildStatuses: Int16 {
        case current
        case archived
    }
    
    var status: ChildStatuses {
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
            print("Finishing session.")
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
            
            // if the user has set their autostartTimers setting to true, `resume` it immediately
            if UserDefaults.standard.bool(forKey: "autostartTimers") {
                session.resume()
            }
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
