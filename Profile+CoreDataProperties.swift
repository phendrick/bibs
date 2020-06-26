//
//  Profile+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 26/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var colorScheme: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var children: NSSet?

}

// MARK: Generated accessors for children
extension Profile {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: Child)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: Child)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}
