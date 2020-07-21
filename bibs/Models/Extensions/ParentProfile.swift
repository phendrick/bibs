//
//  ParentProfile.swift
//  bibs
//
//  Created by Paul Hendrick on 03/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import UIKit

extension ParentProfile {
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
            print("Setting weeklyDataSevenDays to \(newValue)2")
            UserDefaults.standard.set(newValue, forKey: "weeklyDataSevenDays")
        }
    }
    
    public var expressedMilkAvailable: Int {
        10
    }
    
    public var childrenArray: [Child] {
        let set = children as? Set<Child> ?? []
        return set.sorted {$0.wrappedCreatedAt < $1.wrappedCreatedAt}
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
        
        self.addToChildren(child)
        
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
        let activeFeedSessions = childrenArray.flatMap { (child) in
            child.feedSessionsArray.filter { (feedSession) -> Bool in
                feedSession.status == .running
            }
        }
        
        return activeFeedSessions
    }
    
    public var currentFeedSessions: [FeedSession] {
        let activeFeedSessions = childrenArray.flatMap { (child) in
            child.feedSessionsArray.filter { (feedSession) -> Bool in
                feedSession.status == .running || feedSession.status == .paused
            }
        }
        
        return activeFeedSessions
    }
    
    public var suspendedFeedSessions: [FeedSession] {
        let activeFeedSessions = childrenArray.flatMap { (child) in
            child.feedSessionsArray.filter { (feedSession) -> Bool in
                feedSession.status == .suspended
            }
        }
        
        return activeFeedSessions
    }
    
    /// when the application is closed or sent to the background, suspend any currently running timers
    /// by setting their `suspendedAt` value to the current Date()
    public enum SuspensionType {
        case terminated
        case switched
    }
    
    public func suspendActiveFeedSessions(as suspensionType: SuspensionType) {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        for session in activeFeedSessions {
            if suspensionType == .terminated && pauseRunningTimersOnShutdown {
                print("Pausing...")
                session.pause()
            }else {
                print("Suspending...")
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
//        print(total)
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
            
            session.resume(force: true)
            session.objectWillChange.send()
            session.child?.parent?.objectWillChange.send()
        }
    }
    
    public func pauseActiveFeedSessions() {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        print("Pausing active sessions")
        
        for session in activeFeedSessions {
            session.suspendedAt = Date()
            session.pause()
        }
        
        do {
            try context.save()
        }catch {
            fatalError()
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
    
    public var expressedMilkAmount: Int {
        self.expressedBottlesArray.reduce(into: 0) { (total, bottle) in
            total += Int(bottle.amount)
        }
    }
    
    public var expressedMilkGiven: Int {
        self.childrenArray.compactMap { child in
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
            if reducedCounter + bottle.amount > reduceByAmount {
                print("Reducing bottle amount from \(bottle.amount) by \(reduceByAmount - reducedCounter) ")
                bottle.amount -= (reduceByAmount - reducedCounter)
                
                break
            }
            
            print("Setting bottle amount to 0")
            reducedCounter += bottle.amount
            bottle.amount = 0
        }
    }
    
    public enum TrackableItemScope {
        case activeChild
        case parent
        case allChildren
    }
    
    public enum TrackableItemDateRange {
        case today
        case week
        case weekFromMonday
        case weekFrom(Date)
        case month
        case year
        case all
        
        var range: ClosedRange<Date>? {
            switch(self) {
            case .today: return Date().beginningOfDay...Date()
            case .week: return Date().beginningOfWeek...Date()
            case .weekFromMonday: return Date().beginningOfWeekMonday...Date()
            case .weekFrom(let startDate): return startDate...Date()
            case .month: return Date().beginningOfMonth...Date()
            case .year: return Date().beginningOfYear...Date()
            case .all: return nil
            }
        }
        
        var description: String {
            switch(self) {
            case .today: return "Today"
            case .week: return "This week"
            case .weekFromMonday: return "This week"
            case .weekFrom(_): return "Last 7 days"
            case .month: return "This month"
            case .year: return "This year"
            case .all: return "Everything"
            }
        }
        
        var detail: String {
            switch(self) {
                case .today: return "\(Date().beginningOfDay.getFormattedDate(format: "MMMM d YYYY"))"
                case .week: return "\(Date().beginningOfWeek.getFormattedDate(format: "MMMM d")) - \(Date().getFormattedDate(format: "MMMM d YYYY"))"
                case .weekFromMonday: return "\(Date().beginningOfWeek.getFormattedDate(format: "MMMM d")) - \(Date().getFormattedDate(format: "MMMM d YYYY"))"
                case .weekFrom(let startDate): return "\(startDate.getFormattedDate(format: "MMMM d")) - \(Date().getFormattedDate(format: "MMMM d YYYY"))"
                case .month: return "\(Date().beginningOfMonth.getFormattedDate(format: "MMMM d")) - \(Date().getFormattedDate(format: "MMMM d YYYY"))"
                case .year: return "\(Date().beginningOfYear.getFormattedDate(format: "MMMM d")) - \(Date().getFormattedDate(format: "MMMM d YYYY"))"
                case .all: return ""
            }
        }
    }
    
    public func trackedItems(type: TrackableItemScope = .activeChild, within dateRange: TrackableItemDateRange) -> [Trackable] {
        let expressedBottles = self.expressedBottlesArray
        let nappies = self.activeChild?.nappyChangesArray ?? []
        let bottles = self.activeChild?.bottleFeedsArray ?? []
        
        var items: [Trackable] = []
        
        if let range = dateRange.range {
            items.append(contentsOf: expressedBottles.filter { range.contains($0.wrappedCreatedAt)} )
            items.append(contentsOf: nappies.filter { range.contains($0.wrappedCreatedAt)} )
            items.append(contentsOf: bottles.filter { range.contains($0.wrappedCreatedAt)} )
        }else {
            items.append(contentsOf: expressedBottles)
            items.append(contentsOf: nappies)
            items.append(contentsOf: bottles)
        }
        
        items.sort { (lhs, rhs) -> Bool in
            lhs.wrappedCreatedAt < rhs.wrappedCreatedAt
        }
        
        return items
    }
}
