//
//  NappyChange+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 09/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension NappyChange {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NappyChange> {
        return NSFetchRequest<NappyChange>(entityName: "NappyChange")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var state: Int16
    @NSManaged public var amount: Int16
    @NSManaged public var color: Int16
    @NSManaged public var note: String?
    @NSManaged public var child: Child?
    @NSManaged public var changedAt: Date?
}
