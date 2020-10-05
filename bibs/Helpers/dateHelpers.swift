//
//  dateHelpers.swift
//  bibs
//
//  Created by Paul Hendrick on 05/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

func dashboardGreeting(for parent: ParentProfile) -> String {
    let timeOfDayType = Date().timeOfDayType()
    let name = parent.wrappedName
    
    var greeting: String
    
    switch(timeOfDayType) {
    case .morning:
        greeting = "morning_greeting"
    case .afternoon:
        greeting = "hi_greeting"
    case .evening:
        greeting = "evening_greeting"
    case .lateNight:
        greeting = "late_greeting"
    }
    
    
    return String(format: greeting.localized, name)
}

func dashboardSubtitle(for parent: ParentProfile) -> String {
    let timeOfDayType = Date().timeOfDayType()
    //let latestEmotion = parent.latestEmotionType
    
    let lateNightGreetingPrefixes: [String] = [
        "keep_going", "youre_amazing"
    ]
    
    var lateNightgreeting: String {
         lateNightGreetingPrefixes.randomElement()!
    }
    
    var greeting = ""
    
    switch(timeOfDayType) {
    case .lateNight:
        greeting = lateNightgreeting
    case .evening:
        greeting = "had_a_good_day"
    default:
        greeting = "how_are_you_today"
    }
    
    return greeting.localized
}
