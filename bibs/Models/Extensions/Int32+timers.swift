//
//  Int32+timers.swift
//  bibs
//
//  Created by Paul Hendrick on 31/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

typealias Duration = Int32

extension Duration {
    var toHoursMinutesSeconds: (Int, Int, Int) {
        let hours    = Int((self / 100) / 3600)
        let minutes  = Int((self / 100) / 60 % 60)
        let seconds  = Int((self / 100 ) % 60)
        
        return (hours, minutes, seconds)
    }
    
    var formattedHoursAndMinutes: String {
        let (hours, minutes, seconds) = self.toHoursMinutesSeconds
        
        return String.localizedStringWithFormat("%ld hours %ld minutes %ld secs", hours, minutes, seconds)
    }
}
