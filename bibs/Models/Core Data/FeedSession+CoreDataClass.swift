//
//  FeedSession+CoreDataClass.swift
//  bibs
//
//  Created by Paul Hendrick on 26/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData

@objc(FeedSession)
public class FeedSession: NSManagedObject {
    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        
        print("Adding timer to main RunLoop: \(timer)")
        RunLoop.current.add(timer, forMode: .common)
    }
}
