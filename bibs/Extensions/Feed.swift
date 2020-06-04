//
//  Feed+Switchable.swift
//  bibs
//
//  Created by Paul Hendrick on 26/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

extension Feed: Identifiable {
    enum State: Int16 {
        case complete
        case active
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
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            print("OK")
        }
    }

    func setTimerMode(to mode: TimerMode) {
        switch mode {
        case .initial:
            print("Setting TimerMode to: initial")
            timer.invalidate()
        case .paused:
            print("Setting TimerMode to: paused")
            timer.invalidate()
        case .running:
            print("Setting TimerMode to: running")
            timer.fire()
        case .switching:
            print("Setting TimerMode to: switching")
        }
    }

    var wrappedBreadSide: BreastSide {
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

    func stopTimer() {
        timer.invalidate()
    }
}
