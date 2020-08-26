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
        greeting = "Morning"
    case .afternoon:
        greeting = "Hi"
    case .evening:
        greeting = "Evening"
    case .lateNight:
        greeting = "Evening"
    }
    
    
    return String(format: greeting.localized, name)
}

func dashboardSubtitle(for parent: ParentProfile) -> String {
    let timeOfDayType = Date().timeOfDayType()
    //let latestEmotion = parent.latestEmotionType
    
    let lateNightGreetingPrefixes: [String] = [
        "Keep going", "You're amazing"
    ]
    
    var lateNightgreeting: String {
         lateNightGreetingPrefixes.randomElement()!
    }
    
    var greeting = ""
    
    switch(timeOfDayType) {
    case .lateNight:
        greeting = lateNightgreeting
    case .evening:
        greeting = "Had a good day?"
    default:
        greeting = "How are you today?"
    }
    
    return greeting.localized
}
