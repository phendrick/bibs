//
//  NappyChange+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 26/06/2020.
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
    @NSManaged public var child: Child?

}
