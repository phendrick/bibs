
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
        guard let date = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
            return self
        }
        
        return date.beginningOfDay
    }
    
    var beginningOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    
    var beginningOfWeek: Date {
        let components: DateComponents = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        
        return Calendar.current.date(from: components)!
    }
    
    var weekAgo: Date {
        let delta:Double = 3600*24*7
        let date = self.advanced(by: -delta)
        
        return date
    }
    
    var dayAgo: Date {
        let delta:Double = 3600*24*1
        let date = self.advanced(by: -delta)
        
        return date
    }
    
    var plusWeek: Date {
        let delta:Double = 3600*24*7
        let date = self.advanced(by: delta)
        
        return date
    }
    
    var beginningOfWeekMonday: Date {
        return beginningOfWeek.advanced(by: 3600*24)
    }
    
    var beginningOfMonth: Date {
        let components: DateComponents = Calendar.current.dateComponents([.year, .month], from: self)
        
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        guard let date = Calendar.current.date(byAdding: .month, value: 1, to: self.beginningOfMonth) else {
            return self
        }
        
        return date.advanced(by: -1)
    }
    
    var previousMonth: Date {
        guard let date = Calendar.current.date(byAdding: .month, value: -1, to: self) else {
            return self
        }
        
        return date.beginningOfMonth
    }
    
    var nextMonth: Date {
        guard let date = Calendar.current.date(byAdding: .month, value: 1, to: self) else {
            return self
        }
        
        return date.beginningOfMonth
    }
    
    var beginningOfYear: Date {
        let components: DateComponents = Calendar.current.dateComponents([.year], from: self)
        
        return Calendar.current.date(from: components)!
    }
    
    func advancedDate(component: Calendar.Component, by value: Int) -> Date {
        guard let date = Calendar.current.date(byAdding: component, value: value, to: self) else {
            return self
        }
        
        let delta = self.distance(to: date)
        print("ADJUSTING BY \(value) - \(delta), \(self)")
        
        return self.advanced(by: delta)
    }
    
    var isToday: Bool {
        return self.beginningOfDay == Date().beginningOfDay
    }
    
    var isYesterday: Bool {
        guard let yesterdaysDate = Calendar.current.date(byAdding: .day, value: -1, to: Date().beginningOfDay) else {
            return false
        }
        
        let yesterday = yesterdaysDate...yesterdaysDate.endOfDay
        
        return yesterday.contains(self)
    }
    
    var isBeforeYesterday: Bool {
        guard let yesterdaysDate = Calendar.current.date(byAdding: .day, value: -1, to: Date().beginningOfDay) else {
            return false
        }
        
        return yesterdaysDate > self.beginningOfDay
    }
}
