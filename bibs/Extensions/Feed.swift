//
//  Feed+Switchable.swift
//  bibs
//
//  Created by Paul Hendrick on 26/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

extension Feed: Identifiable, Timeable {
    enum FeedStatus: Int16 {
        case active
        case paused
    }
    
    enum BreastSide: Int16 {
        case left
        case right
    }
    
    var status: FeedStatus {
        FeedStatus.init(rawValue: self.state) ?? .active
    }

    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }

    var wrappedBreastSide: BreastSide {
        guard let side = BreastSide(rawValue: self.side) else {
            return .left
        }

        return side
    }

    var currentSide: BreastSide {
        guard let side = BreastSide(rawValue: self.side) else {
            return .left
        }

        return side
    }
    
    func setStatus(to status: FeedStatus) {
//        switch status {
//        case .inactive, .complete:
//        default:
//        }
        state = status.rawValue
    }
    
    var calculatedElapsedTime: (hours: Int, minutes: Int, seconds: Int, hseconds: Int) {
        let hours    = Int((duration / 100) / 3600)
        let minutes  = Int((duration / 100) / 60 % 60)
        let seconds  = Int((duration / 100 ) % 60)
        let hseconds = Int((duration % 100))
        
        return (hours: hours, minutes: minutes, seconds: seconds, hseconds: hseconds)
    }
    
    var formattedElapsedTime: String {
        let hours    = String(calculatedElapsedTime.hours).toPaddedNumber()
        let minutes  = String(calculatedElapsedTime.minutes).toPaddedNumber()
        let seconds  = String(calculatedElapsedTime.seconds).toPaddedNumber()
        let hseconds = String(calculatedElapsedTime.hseconds).toPaddedNumber()
        
        return "\(hours):\(minutes):\(seconds).\(hseconds)"
    }
    
    // MARK private methods
//    private func setTimerMode(to mode: TimerMode) {
//        self.currentTimerMode = mode
//    }
}
