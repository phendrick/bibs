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

class ViewSettings: ObservableObject {
    let objectWillChange = PassthroughSubject<ViewSettings, Never>()
    
    enum InitialView {
        case welcome
        case dashboard
    }
    
    init(initialView: InitialView) {
        self.initialView = initialView
    }
    
    var initialView: InitialView = .welcome {
        didSet {
            objectWillChange.send(self)
        }
    }
}
