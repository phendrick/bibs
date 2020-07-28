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
    
    var hasLargeScreen: Bool {
        UIScreen.main.bounds.size.height > 800
    }
}
