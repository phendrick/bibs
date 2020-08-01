//
//  FoodDiaryEntry+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 29/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension FoodDiaryEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodDiaryEntry> {
        return NSFetchRequest<FoodDiaryEntry>(entityName: "FoodDiaryEntry")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var note: String?
    @NSManaged public var state: Int16
    @NSManaged public var parent: ParentProfile?

}
