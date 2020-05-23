//
//  Expression+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 23/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension Expression {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expression> {
        return NSFetchRequest<Expression>(entityName: "Expression")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var side: Int16
    @NSManaged public var amount: Float
    @NSManaged public var feedSession: FeedSession?

    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
}
