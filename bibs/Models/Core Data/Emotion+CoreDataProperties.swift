//
//  Emotion+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 29/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension Emotion {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Emotion> {
        return NSFetchRequest<Emotion>(entityName: "Emotion")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var note: String?
    @NSManaged public var state: Int16
    @NSManaged public var parent: ParentProfile?

}
