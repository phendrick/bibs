//
//  FeedSession+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 22/05/2020.
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
    @NSManaged public var child: Child?
    @NSManaged public var feeds: NSSet?
    @NSManaged public var expressions: NSSet?

    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
    
    public var feedsArray: [Feed] {
        let set = feeds as? Set<Feed> ?? []
        return set.sorted {$0.wrappedCreatedAt < $1.wrappedCreatedAt}
    }
    
    public var expressionsArray: [Expression] {
        let set = expressions as? Set<Expression> ?? []
        return set.sorted {$0.wrappedCreatedAt < $1.wrappedCreatedAt}
    }
}

// MARK: Generated accessors for feeds
extension FeedSession {

    @objc(addFeedsObject:)
    @NSManaged public func addToFeeds(_ value: Feed)

    @objc(removeFeedsObject:)
    @NSManaged public func removeFromFeeds(_ value: Feed)

    @objc(addExpressionsObject:)
    @NSManaged public func addToExpressions(_ value: Expression)

    @objc(removeExpressionObject:)
    @NSManaged public func removeFromExpression(_ value: Expression)
    
    @objc(addFeeds:)
    @NSManaged public func addToFeeds(_ values: NSSet)

    @objc(removeFeeds:)
    @NSManaged public func removeFromFeeds(_ values: NSSet)

    @objc(addExpressions:)
    @NSManaged public func addToExpressions(_ values: NSSet)

    @objc(removeExpressions:)
    @NSManaged public func removeFromExpressions(_ values: NSSet)
}
