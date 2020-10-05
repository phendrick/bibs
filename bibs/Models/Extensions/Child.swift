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

public typealias Theme = (UIColor, UIColor)

protocol ChartDataDelegate {
}

extension Child: ChartDataDelegate {
}

extension Child: Identifiable {
    var hasActiveFeedSession: Bool {
        self.activeFeedSession != nil
    }
    
    static var Themes: [Int: Theme] {
        [
            0: (
                background: UIColor(named: "HighlightGreen") ?? UIColor.blue,
                foreground: UIColor(named: "HighlightGreenText") ?? UIColor.white
            ),
            1: (
                background: UIColor(named: "HighlightBlue") ?? UIColor.green,
                foreground: UIColor(named: "HighlightBlueText") ?? UIColor.white
            ),
            2: (
                background: UIColor(named: "HighlightPink") ?? UIColor.systemPink,
                foreground: UIColor(named: "HighlightPinkText") ?? UIColor.white
            ),
            3: (
                background: UIColor(named: "HighlightRed") ?? UIColor.red,
                foreground: UIColor(named: "HighlightRedText") ?? UIColor.white
            ),
            4: (
                background: UIColor(named: "HighlightYellow") ?? UIColor.yellow,
                foreground: UIColor(named: "HighlightYellowText") ?? UIColor.white
            )
        ]
    }
    
    public var theme: Theme {
        Child.Themes[Int(self.colorScheme)]
            ??
            (UIColor(named: "HighlightYellow") ?? UIColor.yellow, UIColor(named: "HighlightYellowText") ?? UIColor.white)
    }
    
    public enum ChildStatuses: Int16, Hashable, CaseIterable {
        case current
        case weaning
        case weaningOnly
        case archived
        
        var description: String {
            switch(self) {
            case .current:
                return "breastfeeding".localized
            case .weaning:
                return "breastfeeding_and_Weaning".localized
            case .weaningOnly:
                return "weaning_only".localized
            case .archived:
                return "archived".localized
            }
        }
        
        var editDescription: String {
            switch(self) {
            case .current:
                return "breastfeeding".localized
            case .weaning:
                return "breastfeeding_and_Weaning".localized
            case .weaningOnly:
                return "weaning_only".localized
            case .archived:
                return "archive".localized
            }
        }
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
        
        return feedSessions
    }
    
    public var completedFeedSessionsArray: [FeedSession] {
        let feedSessions = feedSessionsArray.filter {$0.status == .complete}
        
        return feedSessions
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
    
//    var activeFeedSession: FeedSession? {
//        print("Getting feedSessionsArray")
//        return feedSessionsArray.first {
//            $0.status == .paused || $0.status == .running
//        }
//    }
    
    func buildNewFeedSession(side: Feed.BreastSide = .left) -> FeedSession {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        let session       = FeedSession(context: context)
        session.createdAt = Date()
        session.status = .paused
        
        let feed       = Feed(context: context)
        feed.createdAt = Date()
        feed.breastSide = side
        
        session.addToFeeds(feed)
        
        self.addToFeedSessions(session)
        
        return session
    }
    
    func startNewFeedSession() throws {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        /// mark any old feed sessions as complete
        try? self.activeFeedSession?.finish()
        
        var side: Feed.BreastSide = .left
        
        if let currentSession = parent?.currentFeedSessions.filter({$0.child != self}).first {
            side = currentSession.currentBreastSide == side ? side.switched : side
        }
        
        let session = self.buildNewFeedSession(side: side)
        
        self.activeFeedSession = session
        
        self.parent?.profileObserver?.addToActiveFeedSessions(session: session)
        
        print("Starting new feed session", UserDefaults.standard.bool(forKey: "autostartTimers"))
        do {
            /// if the user has set their autostartTimers setting to true, `resume` it immediately
            if UserDefaults.standard.bool(forKey: "autostartTimers") {
                session.resume()
            }
            
            try context.save()
            self.objectWillChange.send()
            self.parent?.profileObserver?.objectWillChange.send()
        }catch {
            print("Error: \(error)")
        }
    }
    
    func completeActiveFeedSession() {
        guard let activeSession = self.activeFeedSession else {
            return
        }
        
        parent?.profileObserver?.removeFromActiveFeedSessions(session: activeSession)
        activeSession.complete()
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
