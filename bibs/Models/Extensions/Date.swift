
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
    
    var lastSevenDays: Date {
        let delta:Double = 3600*24*7
        let date = Date().advanced(by: -delta)
        
        return date.beginningOfDay
    }
    
    var beginningOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var beginningOfWeek: Date {
        let components: DateComponents = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        
        return Calendar.current.date(from: components)!
    }
    
    var beginningOfWeekMonday: Date {
        return beginningOfWeek.advanced(by: 3600*24)
    }
    
    var beginningOfMonth: Date {
        let components: DateComponents = Calendar.current.dateComponents([.year, .month], from: self)
        
        return Calendar.current.date(from: components)!
    }
    
    var beginningOfYear: Date {
        let components: DateComponents = Calendar.current.dateComponents([.year], from: self)
        
        return Calendar.current.date(from: components)!
    }
}
