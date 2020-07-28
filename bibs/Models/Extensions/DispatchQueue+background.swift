//
//  DispatchQueue+background.swift
//  bibs
//
//  Created by Paul Hendrick on 22/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

typealias Dispatch = DispatchQueue

extension Dispatch {

    static func background(_ task: @escaping () -> ()) {
        Dispatch.global(qos: .background).async {
            task()
        }
    }

    static func main(_ task: @escaping () -> ()) {
        Dispatch.main.async {
            task()
        }
    }
}
