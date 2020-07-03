//
//  CustomUIScrollViewDelegate.swift
//  bibs
//
//  Created by Paul Hendrick on 26/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

/// Override the scrollViewDidEndDecelerating method and call a given scrollViewDidEndDeceleratingCallback method to update the current page of the view

class CustomUIScrollViewDelegate: NSObject, UIScrollViewDelegate {
    var scrollViewDidEndDeceleratingCallback: (Int) -> Void
    
    /// vars to determine the current page, given the scroll view offset
    var pageWidth: CGFloat = 0
    var pageCount: Int = 0
    
    init(scrollViewDidEndDeceleratingCallback: @escaping (Int) -> Void) {
        self.scrollViewDidEndDeceleratingCallback = scrollViewDidEndDeceleratingCallback
        
        super.init()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetIndex = Int(scrollView.contentOffset.x / CGFloat(pageWidth))
        
        print(scrollView.contentOffset)
        
        self.scrollViewDidEndDeceleratingCallback(offsetIndex)
    }
}
