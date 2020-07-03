//
//  UINavigationController+color.swift
//  bibs
//
//  Created by Paul Hendrick on 29/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import UIKit

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        let standard = UINavigationBarAppearance()
        standard.backgroundColor = .white //When you scroll or you have title (small one)

        let compact = UINavigationBarAppearance()
        compact.backgroundColor = .white //compact-height

        let scrollEdge = UINavigationBarAppearance()
        scrollEdge.backgroundColor = .white //When you have large title

        navigationBar.standardAppearance = standard
        navigationBar.compactAppearance = compact
        navigationBar.scrollEdgeAppearance = scrollEdge
    }
}
