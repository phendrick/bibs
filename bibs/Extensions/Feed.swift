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
        case inactive
        case active
        case complete
    }
    
    enum BreastSide: Int16 {
        case left
        case right
    }

    enum TimerMode {
        case initial
        case running
        case paused
        case switching
    }

    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
    
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            self.feedSession?.child?.objectWillChange.send()
            
            if self.currentTimerMode == .paused {
                timer.invalidate()
            }
            
            self.duration += 1
        }
    }
    
    
    var status: FeedStatus {
        get {
            if let feedStatus = FeedStatus(rawValue: self.state) {
                return feedStatus
            }
            
            return .inactive
        }
        
        set(newValue) {
            self.state = newValue.rawValue
        }
    }
    
    func startTimer() {
        self.currentTimerMode = .running
        self.timer.fire()
    }

    func stopTimer() {
        self.currentTimerMode = .paused
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
        self.state = Int16(status.rawValue)
        
        switch status {
        case .inactive, .complete:
            self.stopTimer()
        default:
            self.startTimer()
        }
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
    private func setTimerMode(to mode: TimerMode) {
        self.currentTimerMode = mode
    }
}
