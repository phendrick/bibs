//
//  ParentProfile+CoreDataClass.swift
//  bibs
//
//  Created by Paul Hendrick on 09/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


public class ParentProfile: NSManagedObject {
    var activeChild: Child?
}
