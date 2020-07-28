//
//  Nap+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 23/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension Nap {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Nap> {
        return NSFetchRequest<Nap>(entityName: "Nap")
    }

    @NSManaged public var state: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var nappedAt: Date?
    @NSManaged public var duration: Int32
    @NSManaged public var child: Child?

}
