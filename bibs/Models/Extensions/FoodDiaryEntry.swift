//
//  FoodDiaryEntry.swift
//  bibs
//
//  Created by Paul Hendrick on 29/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

extension FoodDiaryEntry {
    public var wrappedCreatedAt: Date {
        get {createdAt ?? Date()}
        set {createdAt = newValue}
    }
}
