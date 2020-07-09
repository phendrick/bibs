//
//  BottleFeed+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 06/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension BottleFeed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BottleFeed> {
        return NSFetchRequest<BottleFeed>(entityName: "BottleFeed")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var child: Child?

}
