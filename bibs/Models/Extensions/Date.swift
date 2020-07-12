
//
//  SwiftUIView.swift
//  bibs
//
//  Created by Paul Hendrick on 04/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
import Foundation

extension Date {
    enum TimeOfDayTypes {
        case morning
        case afternoon
        case evening
        case lateNight
    }
    
   func getFormattedDate(format: String = "EEEE, MMMM d, h:mm a") -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        
        return dateformat.string(from: self)
    }
    
    func timeOfDayType() -> TimeOfDayTypes {
        let hour = Calendar.current.component(.hour, from: self)
        var timeOfDayType: TimeOfDayTypes = .evening
        
        switch(hour) {
        case 0..<5:
            timeOfDayType = TimeOfDayTypes.lateNight
        case 5..<12:
            timeOfDayType = TimeOfDayTypes.morning
        case 12..<17:
            timeOfDayType = TimeOfDayTypes.afternoon
        default:
            timeOfDayType = TimeOfDayTypes.evening
        }
        
        return timeOfDayType
    }
    
    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
}
