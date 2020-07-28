//
//  Snack+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 26/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension Snack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Snack> {
        return NSFetchRequest<Snack>(entityName: "Snack")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var state: Int16
    @NSManaged public var child: Child?
    @NSManaged public var note: String?

}
