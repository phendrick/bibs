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
    
    var greeting = "Hi, \(name)"
    
    switch(timeOfDayType) {
    case .morning:
        greeting = "Morning, \(name)"
    case .afternoon:
        greeting = "Hi, \(name)"
    case .evening:
        greeting = "Evening, \(name)"
    case .lateNight:
        greeting = "Evening, \(name)"
    }
    
    return greeting
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
    
//    let greetingVariants: [Emotion.EmotionType: [(Date.TimeOfDayTypes, String)]] = [
//
//        .down: [],
//        .enthusiastic: [],
//        .excited: [],
//        .happy: [],
//        .loved: [],
//        .sad: [
//            (Date.TimeOfDayTypes.lateNight, "Need support"), (Date.TimeOfDayTypes.lateNight, "Sometimes it's easier to talk to someone")
//        ],
//        .tired: []
//    ]
    
    var greeting = ""
    
    switch(timeOfDayType) {
    case .lateNight:
        greeting = lateNightgreeting
    case .evening:
        greeting = "Had a good day?"
    default:
        greeting = "How are you today?"
    }
    
    return greeting
}
