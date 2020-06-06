//
//  Feed+CoreDataClass.swift
//  bibs
//
//  Created by Paul Hendrick on 04/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
//

import Foundation
import CoreData
import Combine

public class Feed: NSManagedObject {
    var currentTimerMode: TimerMode = .initial
}
