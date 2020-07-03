//
//  ParentProfile+CoreDataClass.swift
//  bibs
//
//  Created by Paul Hendrick on 03/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ParentProfile)
public class ParentProfile: NSManagedObject {
    var activeChild: Child? 
}
