//
//  ExpressedBottle+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 09/07/2020.
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
    @NSManaged public var parent: ParentProfile?

}
