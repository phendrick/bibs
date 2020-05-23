//
//  Feed+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 22/05/2020.
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
    @NSManaged public var side: Int16
    @NSManaged public var duration: Int16
    @NSManaged public var feedSession: FeedSession?
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
}
