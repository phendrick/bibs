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
    
    var toFormattedString: String {
        let (hours, minutes, seconds) = self.toHoursMinutesSeconds
        print(hours, minutes, seconds)
        var output = ""
        var join = ""
        
        var hourString = ""
        var minutesString = ""
        var secondsString = ""
        
        if hours > 0 {
            hourString = String.localizedStringWithFormat(NSLocalizedString("%ld hours", comment: ""), hours)
            output.append("\(hourString)")
            join = " "
        }
        
        if minutes > 0 {
            minutesString = String.localizedStringWithFormat(NSLocalizedString("%ld minutes", comment: ""), minutes)
            output.append("\(join)\(minutesString)")
            
            join = " and "
        }
        
        if seconds > 0 {
            secondsString = String.localizedStringWithFormat(NSLocalizedString("%ld seconds", comment: ""), seconds)
            output.append("\(join)\(secondsString)")
        }
        
        
        return output
    }
}
