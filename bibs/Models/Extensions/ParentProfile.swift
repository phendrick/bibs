//
//  ParentProfile.swift
//  bibs
//
//  Created by Paul Hendrick on 03/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension ParentProfile {
    /// @UserDefaultSetting var autostartTimer: Bool = true
    
    public var autostartTimer: Bool {
        get {
            UserDefaults.standard.bool(forKey: "autostartTimers")
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "autostartTimers")
        }
    }
    
    public var pauseTimerWhenSwitching: Bool {
        get {
            UserDefaults.standard.bool(forKey: "pauseTimerWhenSwitching")
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "pauseTimerWhenSwitching")
        }
    }
    
    public var pauseRunningTimersOnShutdown: Bool {
        get {
            UserDefaults.standard.bool(forKey: "pauseRunningTimersOnShutdown")
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "pauseRunningTimersOnShutdown")
        }
    }
    
    public var startOfWeekDay: Int {
        get {
            UserDefaults.standard.integer(forKey: "startOfWeekDay")
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "startOfWeekDay")
        }
    }
    
    public var weeklyDataSevenDays: Bool {
        get {
            UserDefaults.standard.bool(forKey: "weeklyDataSevenDays")
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "weeklyDataSevenDays")
        }
    }
    
    public var showFoodDiaryPrompt: Bool {
        get {
            UserDefaults.standard.bool(forKey: "showFoodDiaryPrompt")
        }
        
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "showFoodDiaryPrompt")
        }
    }
    
    public var todaysFeedsOverview: (Int?, String, Date?) {
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo   = calendar.date(byAdding: .day, value: 1, to: dateFrom) ?? dateFrom
        
        let dateRange = dateFrom..<dateTo
        
        let feeds = FeedSession.trackableItemsWithinRange(range: dateRange, context: self.managedObjectContext).filter{$0.status == .complete}
        
        let duration: Duration = feeds.reduce(into: 0, { (result, session) in
            result += session.duration
        })
        
        var overview = ""
        
        if duration > 0 {
            overview = duration.formattedHoursAndMinutes
        }else {
            overview = "None today".localized
        }
        
        let count: Int? = feeds.count > 0 ? feeds.count : nil
        
        return (count, overview, feeds.last?.wrappedCreatedAt)
    }
    
    public var todaysNappiesOverview: (Int?, Int, Int, Date?) {
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo   = calendar.date(byAdding: .day, value: 1, to: dateFrom) ?? dateFrom
        
        let dateRange = dateFrom..<dateTo
        
        let nappies = NappyChange.trackableItemsWithinRange(range: dateRange, context: self.managedObjectContext)
        
        let count: Int? = nappies.count > 0 ? nappies.count : nil
        
        if nappies.count > 0 {
            let wet = nappies.filter {$0.status == .wet}
            let dirty = nappies.filter {$0.status == .dirty}
            let both = nappies.filter {$0.status == .both}
            
            return (count, wet.count+both.count, dirty.count+both.count, nappies.last?.wrappedCreatedAt)
        }else {
            return (count, 0, 0, nil)
        }
    }
    
    public var todaysNapsOverview: (Int?, String?, Date?) {
        let date = Date()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo   = calendar.date(byAdding: .day, value: 1, to: dateFrom) ?? dateFrom
        
        let dateRange = dateFrom..<dateTo
        
        let naps = Nap.trackableItemsWithinRange(range: dateRange, context: self.managedObjectContext)
        
        let duration: Duration = naps.reduce(into: 0, { (result, session) in
            result += session.duration
        })
        
        var overview: String? 
        
        if duration > 0 {
            overview = duration.formattedHoursAndMinutes
        }
        
        let count = naps.count > 0 ? naps.count : nil
        
        return (count, overview, naps.last?.wrappedCreatedAt)
    }
    
    public var childrenArray: [Child] {
        let set = children as? Set<Child> ?? []
        return set.sorted {$0.wrappedCreatedAt < $1.wrappedCreatedAt}
    }
    
    public var breastfeedingChildrenArray: [Child] {
        var set = children as? Set<Child> ?? []
        
        // since we can only have 2 children feeding at any one time, if the number of feed sessions is 2
        // just return the children associated with those sessions
        guard let profile = self.profileObserver, profile.activeFeedSessions.count < 2 else {
            return self.profileObserver!.activeFeedSessions.filter{$0.child != nil}.map {$0.child!}
        }
        
        set = set.filter {
            [Child.ChildStatuses.current, Child.ChildStatuses.weaning].contains($0.status)
        }
        
        return set.sorted {$0.wrappedCreatedAt < $1.wrappedCreatedAt}
    }
    
    public var activeChildrenArray: [Child] {
        return childrenArray.filter {$0.status != .archived}
    }
    
    public var expressedBottlesArray: [ExpressedBottle] {
        let set = expressedBottles as? Set<ExpressedBottle> ?? []
        return set.sorted {$0.wrappedCreatedAt < $1.wrappedCreatedAt}
    }
    
    func buildChildObject() -> Child {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        let child = Child(context: context)
        child.id = UUID()
        child.createdAt = Date()
        
        return child
    }
    
    func setActiveChild(child: Child?) {
        guard let child = child, let id = child.id?.description, child.status == .current else {
            return
        }
        
        self.activeChild = child
        UserDefaults.standard.set(id, forKey: "ActiveChild")
    }
    
    func restoreActiveChild() -> Bool {
        let id = UserDefaults.standard.string(forKey: "ActiveChild")
        
        let child = childrenArray.first { (child) -> Bool in
            child.id?.description == id
        }
        
        if let activeChild = child {
            self.activeChild = activeChild
            return true
        }
        
        if let lastChild = childrenArray.last {
            self.activeChild = lastChild
            return true
        }
        
        return false
    }
    
    public var activeFeedSessions: [FeedSession] {
        let activeFeedSessions:[FeedSession] = childrenArray.compactMap { (child) in
            guard let feedSession = child.activeFeedSession else {
                return nil
            }
            
            return feedSession.status == .running ? feedSession : nil
        }
        
        return activeFeedSessions
    }
    
    public var currentFeedSessions: [FeedSession] {
        let activeFeedSessions:[FeedSession] = childrenArray.compactMap { (child) in
            guard let feedSession = child.activeFeedSession else {
                return nil
            }
            
            let currentStatuses = [FeedSession.FeedSessionStatus.running, FeedSession.FeedSessionStatus.paused]
            
            return currentStatuses.contains(feedSession.status) ? feedSession : nil
        }
        
        if activeFeedSessions.count > 1 {
            return activeFeedSessions.sorted { (lhs, rhs) -> Bool in
                lhs.currentBreastSide == .left
            }
        }
        
        return activeFeedSessions
    }
    
    public var childrenWithoutCurrentFeedSessions: [Child] {
        return childrenArray.filter {$0.status == .current && $0.activeFeedSession == nil}
    }
    
    public var suspendedFeedSessions: [FeedSession] {
        guard let context = self.managedObjectContext else {
            return []
        }
        
        let suspendedSessionPredicate = NSPredicate(format: "state IN %@", [FeedSession.FeedSessionStatus.suspended.rawValue, FeedSession.FeedSessionStatus.paused.rawValue])
        let feedSessionFetchRequest:NSFetchRequest<FeedSession> = FeedSession.fetchRequest()
        feedSessionFetchRequest.predicate = suspendedSessionPredicate
        
        do {
            let feedSessions = try context.fetch(feedSessionFetchRequest)
            return feedSessions
        }catch {
            return []
        }
    }
    
    /// when the application is closed or sent to the background, suspend any currently running timers
    /// by setting their `suspendedAt` value to the current Date()
    public enum SuspensionType {
        case terminated
        case switched
    }
    
    public func suspendActiveFeedSessions(as suspensionType: SuspensionType) {
        guard let context = self.managedObjectContext else {
            print("no context")
            fatalError()
        }
        
        for session in activeFeedSessions {
            if suspensionType == .terminated && pauseRunningTimersOnShutdown {
                session.pause()
            }else {
                session.suspend()
            }
        }
        
        try? context.save()
    }
    
    /// when resuming the application, we should rehydrate a suspended session by updating the `duration` of its
    /// `currentFeed` by the number of hundredths of a second since its suspension
//    var timerDriftWithinPermittedRange: Bool {
//        let total = suspendedFeedSessions.reduce(into: 0.0) { (count, session) in
//            let timeInterval = session.suspendedAt?.distance(to: Date())
//
//            if let difference = timeInterval {
//                count += difference
//            }
//        }
//
//        // 30 mins max drift allowed - fixme: make this a config var
//        return total < 1800
//    }
    
    public func resumeSuspendedFeedSessions() {
        let currentDate = Date()
        
        for session in suspendedFeedSessions {
            let timeDifference = session.suspendedAt?.distance(to: currentDate)
                        
            if let difference = timeDifference, let feed = session.currentFeed {
                feed.duration += Int32(difference*100)
                
                // clear out the suspendedAt value so we don't increment the timer again
                session.suspendedAt = nil
            }
            
            session.child?.activeFeedSession = session
            
            // if we've lost our active feed session for whatever reason
            // (save failed due to 0 battery etc), reassign it here.
            if self.profileObserver?.activeFeedSessions.firstIndex(of: session) == nil {
                self.profileObserver?.activeFeedSessions.append(session)
            }
            
            // ready to go - unsuspend this feed session
            session.unsuspend()
            
            try? self.managedObjectContext?.save()
            
            session.objectWillChange.send()
            session.child?.parent?.objectWillChange.send()
        }
    }
    
    public var wrappedCreatedAt: Date {
        get {createdAt ?? Date()}
        set {createdAt = newValue}
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
    
    public var expressedMilkGiven: Int {
        print("expressedMilkGiven")
        return self.childrenArray.compactMap { child in
            child.bottleFeedsArray.filter { (bottleFeed) -> Bool in
                bottleFeed.status == .expressedMilk
            }.reduce(into: 0) { (total, bottleFeed) in
                total += Int(bottleFeed.amount)
            }
        }.reduce(into: 0) { (total, amount) in
            total += amount
        }
    }
    
    public func reduceExpressedBottles(_ bottles: [ExpressedBottle], by reduceByAmount: Int16) {
        let sortedBottles = bottles.sorted { (b1, b2) -> Bool in
            b1.amount < b2.amount
        }
        
        var reducedCounter: Int16 = 0
        
        for bottle in sortedBottles {
            if bottle.status == .frozen {
                bottle.status = .thawed
            }
            
            if reducedCounter + bottle.amount > reduceByAmount {
                bottle.amount -= (reduceByAmount - reducedCounter)
                
                break
            }
            
            reducedCounter += bottle.amount
            bottle.amount = 0
        }
    }
    
    public var emotionsArray: [Emotion] {
        let set = emotions as? Set<Emotion> ?? []
        
        return set.sorted {$0.wrappedCreatedAt > $1.wrappedCreatedAt}
    }
    
    public var latestEmotionType: Emotion.EmotionType {
        return emotionsArray.first?.status ?? Emotion.EmotionType.happy
    }
    
}
