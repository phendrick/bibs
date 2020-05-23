//
//  Setting+CoreDataProperties.swift
//  bibs
//
//  Created by Paul Hendrick on 22/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData


extension Setting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Setting> {
        return NSFetchRequest<Setting>(entityName: "Setting")
    }

    @NSManaged public var name: String?
    @NSManaged public var valueKey: Int16
    
    var wrappedName: String {
        name ?? ""
    }

}
