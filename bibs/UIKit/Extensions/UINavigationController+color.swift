//
//  UINavigationController+color.swift
//  bibs
//
//  Created by Paul Hendrick on 29/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import UIKit
import SwiftUI

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        let standard = UINavigationBarAppearance()

        standard.backgroundColor = UIColor.systemBackground //When you scroll or you have title (small one)
        standard.shadowColor = .clear
        standard.shadowImage = nil
        
        let compact = UINavigationBarAppearance()
        compact.backgroundColor = UIColor.systemBackground //compact-height
        compact.shadowColor = .clear
        compact.shadowImage = nil

        let scrollEdge = UINavigationBarAppearance()
        scrollEdge.backgroundColor = UIColor.systemBackground //When you have large title
        scrollEdge.shadowColor = .clear
        scrollEdge.shadowImage = nil

        navigationBar.standardAppearance = standard
        navigationBar.compactAppearance = compact
        navigationBar.scrollEdgeAppearance = scrollEdge
    }
}
