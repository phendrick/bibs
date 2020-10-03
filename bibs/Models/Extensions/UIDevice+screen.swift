//
//  UIDevice+safeArea.swift
//  bibs
//
//  Created by Paul Hendrick on 24/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

extension UIDevice {
    var hasNotch: Bool {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottom = window?.safeAreaInsets.bottom ?? 0
        
        return bottom > 0
    }
    
    var notchHeight: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let notchHeight = window?.safeAreaInsets.top ?? 0
        
        print(notchHeight)
        return notchHeight
    }
    
    var hasLargeScreen: Bool {
        UIScreen.main.bounds.size.height > 800
    }
}

//extension UINavigationController {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//
//    let standard = UINavigationBarAppearance()
//    standard.backgroundColor = UIColor.systemRed //When you scroll or you have title (small one)
//
//    let compact = UINavigationBarAppearance()
//    compact.backgroundColor = UIColor.systemRed //compact-height
//
//    let scrollEdge = UINavigationBarAppearance()
//    scrollEdge.backgroundColor = UIColor.systemRed //When you have large title
//
//    navigationBar.standardAppearance = standard
//    navigationBar.compactAppearance = compact
//    navigationBar.scrollEdgeAppearance = scrollEdge
// }
//}
