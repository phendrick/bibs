//
//  chartHelpers.swift
//  bibs
//
//  Created by Paul Hendrick on 29/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import UIKit

func barValue(value: CGFloat, maxValue: Double, chartHeight: CGFloat = 160) -> CGFloat {
    guard value > 0 else {
        return value
    }
    
    let multiplier = chartHeight / CGFloat(maxValue)
    return (value * multiplier)
}
