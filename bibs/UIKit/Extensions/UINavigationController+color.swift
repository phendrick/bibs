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
        standard.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0) //When you scroll or you have title (small one)
        standard.shadowColor = .white
        standard.shadowImage = nil
        
        let compact = UINavigationBarAppearance()
        compact.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0) //compact-height
        compact.shadowColor = .white
        compact.shadowImage = nil
        
        let scrollEdge = UINavigationBarAppearance()
        scrollEdge.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0) //When you have large title
        scrollEdge.shadowColor = .white
        scrollEdge.shadowImage = nil

        navigationBar.standardAppearance = standard
        navigationBar.compactAppearance = compact
        navigationBar.scrollEdgeAppearance = scrollEdge
    }
}
