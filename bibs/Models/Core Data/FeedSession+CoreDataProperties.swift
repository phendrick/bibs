//
//  FeedSession+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 26/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension FeedSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedSession> {
        return NSFetchRequest<FeedSession>(entityName: "FeedSession")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var state: Int16
    @NSManaged public var child: Child?
    @NSManaged public var feeds: NSSet?

}

// MARK: Generated accessors for feeds
extension FeedSession {

    @objc(addFeedsObject:)
    @NSManaged public func addToFeeds(_ value: Feed)

    @objc(removeFeedsObject:)
    @NSManaged public func removeFromFeeds(_ value: Feed)

    @objc(addFeeds:)
    @NSManaged public func addToFeeds(_ values: NSSet)

    @objc(removeFeeds:)
    @NSManaged public func removeFromFeeds(_ values: NSSet)

}
