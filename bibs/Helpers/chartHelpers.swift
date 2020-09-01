//
//  chartHelpers.swift
//  bibs
//
//  Created by Paul Hendrick on 29/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import UIKit

func barValue(value: CGFloat, maxValue: Double, chartSize: CGFloat = 160) -> CGFloat {
    guard value > 0, maxValue > 0 else {
        return value
    }
    
    let multiplier = chartSize / CGFloat(maxValue)
    
    return (value * multiplier)
}

func printTimeElapsedWhenRunningCode(title:String, operation:()->()) {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    print("\n\nTime elapsed for \(title): \(timeElapsed) s.\n\n")
}

func timeElapsedInSecondsWhenRunningCode(operation: ()->()) -> Double {
    let startTime = CFAbsoluteTimeGetCurrent()
    operation()
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    return Double(timeElapsed)
}
