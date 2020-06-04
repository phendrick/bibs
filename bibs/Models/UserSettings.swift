//
//  ViewRouter.swift
//  Bibs
//
//  Created by Paul Hendrick on 20/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import Foundation
import Combine

class UserSettings: ObservableObject {
    let objectWillChange = PassthroughSubject<UserSettings, Never>()
    
    var currentChild: Child? {
        didSet {
            objectWillChange.send(self)
        }
    }
}
