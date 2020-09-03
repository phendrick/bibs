//
//  Trackable.swift
//  bibs
//
//  Created by Paul Hendrick on 15/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

public protocol Trackable {
    associatedtype StatusType: Hashable & CaseIterable
    
    var wrappedCreatedAt: Date {get}
    var title: String {get}
    var details: String {get}
    var trackableUnit: Int32 {get}
    var status: StatusType {get set}
}

public protocol TrackableStatus {
    var description: String {get}
    var emoji: String {get}
}
