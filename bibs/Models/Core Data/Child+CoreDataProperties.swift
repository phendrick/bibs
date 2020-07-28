//
//  Child+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 26/07/2020.
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
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var imageId: Int16
    @NSManaged public var isBorn: Bool
    @NSManaged public var name: String?
    @NSManaged public var state: Int16
    @NSManaged public var bottleFeeds: NSSet?
    @NSManaged public var feedSessions: NSSet?
    @NSManaged public var nappyChanges: NSSet?
    @NSManaged public var naps: NSSet?
    @NSManaged public var parent: ParentProfile?
    @NSManaged public var snacks: NSSet?
}

// MARK: Generated accessors for bottleFeeds
extension Child {

    @objc(addBottleFeedsObject:)
    @NSManaged public func addToBottleFeeds(_ value: BottleFeed)

    @objc(removeBottleFeedsObject:)
    @NSManaged public func removeFromBottleFeeds(_ value: BottleFeed)

    @objc(addBottleFeeds:)
    @NSManaged public func addToBottleFeeds(_ values: NSSet)

    @objc(removeBottleFeeds:)
    @NSManaged public func removeFromBottleFeeds(_ values: NSSet)

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

// MARK: Generated accessors for nappyChanges
extension Child {

    @objc(addNappyChangesObject:)
    @NSManaged public func addToNappyChanges(_ value: NappyChange)

    @objc(removeNappyChangesObject:)
    @NSManaged public func removeFromNappyChanges(_ value: NappyChange)

    @objc(addNappyChanges:)
    @NSManaged public func addToNappyChanges(_ values: NSSet)

    @objc(removeNappyChanges:)
    @NSManaged public func removeFromNappyChanges(_ values: NSSet)

}

// MARK: Generated accessors for naps
extension Child {

    @objc(addNapsObject:)
    @NSManaged public func addToNaps(_ value: Nap)

    @objc(removeNapsObject:)
    @NSManaged public func removeFromNaps(_ value: Nap)

    @objc(addNaps:)
    @NSManaged public func addToNaps(_ values: NSSet)

    @objc(removeNaps:)
    @NSManaged public func removeFromNaps(_ values: NSSet)

}

// MARK: Generated accessors for snacks
extension Child {

    @objc(addSnacksObject:)
    @NSManaged public func addToSnacks(_ value: Snack)

    @objc(removeSnacksObject:)
    @NSManaged public func removeFromSnacks(_ value: Snack)

    @objc(addSnacks:)
    @NSManaged public func addToSnacks(_ values: NSSet)

    @objc(removeSnacks:)
    @NSManaged public func removeFromSnacks(_ values: NSSet)

}
