//
//  ParentProfile+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 09/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension ParentProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ParentProfile> {
        return NSFetchRequest<ParentProfile>(entityName: "ParentProfile")
    }

    @NSManaged public var colorScheme: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var expressedMilkAmount: Int16
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var children: NSSet?
    @NSManaged public var expressedBottles: NSSet?

}

// MARK: Generated accessors for children
extension ParentProfile {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: Child)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: Child)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}

// MARK: Generated accessors for expressedBottles
extension ParentProfile {

    @objc(addExpressedBottlesObject:)
    @NSManaged public func addToExpressedBottles(_ value: ExpressedBottle)

    @objc(removeExpressedBottlesObject:)
    @NSManaged public func removeFromExpressedBottles(_ value: ExpressedBottle)

    @objc(addExpressedBottles:)
    @NSManaged public func addToExpressedBottles(_ values: NSSet)

    @objc(removeExpressedBottles:)
    @NSManaged public func removeFromExpressedBottles(_ values: NSSet)

}
