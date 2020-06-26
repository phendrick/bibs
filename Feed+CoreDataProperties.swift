//
//  Feed+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 26/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension Feed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feed> {
        return NSFetchRequest<Feed>(entityName: "Feed")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var duration: Int32
    @NSManaged public var side: Int16
    @NSManaged public var state: Int16
    @NSManaged public var feedSession: FeedSession?

}
