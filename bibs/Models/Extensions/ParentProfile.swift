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
        
        print(suspensionType, activeFeedSessions.count)
        
        for session in activeFeedSessions {
            if pauseRunningTimersOnShutdown {
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
    
    public func incrementFeedSessionTime() {
        
    }
    
    private func pauseActiveFeedSessions() {
        guard let context = self.managedObjectContext else {
            fatalError()
        }
        
        print("Pausing active sessions")
        
        for session in activeFeedSessions {
            session.suspendedAt = Date()
            session.pause()
            
            do {
                try context.save()
            }catch {
                fatalError()
            }
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
}
