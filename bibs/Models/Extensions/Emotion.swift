//
//  Emotion.swift
//  bibs
//
//  Created by Paul Hendrick on 01/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

extension Emotion {
    public enum EmotionType: Int16, CaseIterable {
        case happy = 5
        case tired = 4
        case down = 2
        case sad = 1
        case excited = 7
        case enthusiastic = 6
        case loved = 8
        
        var description: String {
            switch(self) {
            case .happy: return "Happy"
            case .tired: return "Tired"
            case .down: return "A bit down"
            case .sad: return "Sad"
            case .excited: return "Excited"
            case .enthusiastic: return "Enthusiastic"
            case .loved: return "Loved"
            }
        }
        
        var emoji: String {
            switch(self) {
            case .happy: return "😊"
            case .tired: return "🥱"
            case .down: return "😞"
            case .sad: return "😢"
            case .excited: return "😆"
            case .enthusiastic: return "🥳"
            case .loved: return "😍"
            }
        }
    }
    
    public var status: EmotionType {
        get {
            EmotionType.init(rawValue: self.state) ?? .happy
        }
        
        set(newValue) {
            state = newValue.rawValue
        }
    }
    
    public var wrappedCreatedAt: Date {
        createdAt ?? Date()
    }
}
