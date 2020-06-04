//
//  Child+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 04/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension Child {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Child> {
        return NSFetchRequest<Child>(entityName: "Child")
    }

    @NSManaged public var colorScheme: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var image: Data?
    @NSManaged public var imageId: Int16
    @NSManaged public var isBorn: Bool
    @NSManaged public var name: String?
    @NSManaged public var state: Int16
    @NSManaged public var feedSessions: NSSet?

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
