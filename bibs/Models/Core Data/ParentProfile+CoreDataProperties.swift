//
//  ParentProfile+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 29/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension ParentProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ParentProfile> {
        return NSFetchRequest<ParentProfile>(entityName: "ParentProfile")
    }

    @NSManaged public var colorScheme: Int16
    @NSManaged public var createdAt: Date?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var children: NSSet?
    @NSManaged public var expressedBottles: NSSet?
    @NSManaged public var emotions: NSSet?
    @NSManaged public var foodDiaryEntries: NSSet?

}

// MARK: Generated accessors for children
extension ParentProfile {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: Child)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: Child)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: NSSet)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: NSSet)

}

// MARK: Generated accessors for expressedBottles
extension ParentProfile {

    @objc(addExpressedBottlesObject:)
    @NSManaged public func addToExpressedBottles(_ value: ExpressedBottle)

    @objc(removeExpressedBottlesObject:)
    @NSManaged public func removeFromExpressedBottles(_ value: ExpressedBottle)

    @objc(addExpressedBottles:)
    @NSManaged public func addToExpressedBottles(_ values: NSSet)

    @objc(removeExpressedBottles:)
    @NSManaged public func removeFromExpressedBottles(_ values: NSSet)

}

// MARK: Generated accessors for emotions
extension ParentProfile {

    @objc(addEmotionsObject:)
    @NSManaged public func addToEmotions(_ value: Emotion)

    @objc(removeEmotionsObject:)
    @NSManaged public func removeFromEmotions(_ value: Emotion)

    @objc(addEmotions:)
    @NSManaged public func addToEmotions(_ values: NSSet)

    @objc(removeEmotions:)
    @NSManaged public func removeFromEmotions(_ values: NSSet)

}

// MARK: Generated accessors for foodDiaryEntries
extension ParentProfile {

    @objc(addFoodDiaryEntriesObject:)
    @NSManaged public func addToFoodDiaryEntries(_ value: FoodDiaryEntry)

    @objc(removeFoodDiaryEntriesObject:)
    @NSManaged public func removeFromFoodDiaryEntries(_ value: FoodDiaryEntry)

    @objc(addFoodDiaryEntries:)
    @NSManaged public func addToFoodDiaryEntries(_ values: NSSet)

    @objc(removeFoodDiaryEntries:)
    @NSManaged public func removeFromFoodDiaryEntries(_ values: NSSet)

}
