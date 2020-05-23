//
//  Child+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 22/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData
import SwiftUI

extension Child {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Child> {
        return NSFetchRequest<Child>(entityName: "Child")
    }

    @NSManaged public var colorScheme: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var image: Data?
    @NSManaged public var isBorn: Bool
    @NSManaged public var name: String?
    @NSManaged public var feedSessions: NSSet?
    
    public var wrappedColorScheme: Int {
        Int(colorScheme)
    }
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
    public var wrappedDueDate: Date {
        dueDate ?? Date()
    }
    
    public var wrappedImage: Image {
        Image(systemName: "multiply")
    }
    
    public var wrappedName: String {
        name ?? ""
    }
    
    public var feedSessionsArray: [FeedSession] {
        let set = feedSessions as? Set<FeedSession> ?? []
        return set.sorted {
            $0.wrappedCreatedAt < $1.wrappedCreatedAt
        }
    }
    
}

// MARK: Generated accessors for feedSessions
extension Child {

    @objc(addFeedSessionsObject:)
    @NSManaged public func addToFeedSessions(_ value: FeedSession)

    @objc(removeFeedSessionsObject:)
    @NSManaged public func removeFromFeedSessions(_ value: FeedSession)

    @objc(addFeedSessions:)
    @NSManaged public func addToFeedSessions(_ values: NSSet)

    @objc(removeFeedSessions:)
    @NSManaged public func removeFromFeedSessions(_ values: NSSet)

}
