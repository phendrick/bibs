//
//  ExpressedBottle+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 10/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension ExpressedBottle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExpressedBottle> {
        return NSFetchRequest<ExpressedBottle>(entityName: "ExpressedBottle")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var amountUsed: Int16
    @NSManaged public var state: Int16
    @NSManaged public var parent: ParentProfile?
    @NSManaged public var bottleFeeds: NSSet?

}

// MARK: Generated accessors for bottleFeeds
extension ExpressedBottle {

    @objc(addBottleFeedsObject:)
    @NSManaged public func addToBottleFeeds(_ value: BottleFeed)

    @objc(removeBottleFeedsObject:)
    @NSManaged public func removeFromBottleFeeds(_ value: BottleFeed)

    @objc(addBottleFeeds:)
    @NSManaged public func addToBottleFeeds(_ values: NSSet)

    @objc(removeBottleFeeds:)
    @NSManaged public func removeFromBottleFeeds(_ values: NSSet)

}
