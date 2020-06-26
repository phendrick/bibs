//
//  Timeable.swift
//  bibs
//
//  Created by Paul Hendrick on 26/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import CoreData

protocol Timeable {
    var duration: Int32 {get}
    
    var calculatedElapsedTime: (hours: Int, minutes: Int, seconds: Int, hseconds: Int) {get}
}
