//
//  Emotion.swift
//  bibs
//
//  Created by Paul Hendrick on 01/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation

extension Emotion {
    public enum EmotionType: Int16, CaseIterable, Hashable {
        
        case happy = 4
        case enthusiastic = 5
        case excited = 6
        case loved = 7
        
        case tired = 3
        
        case sad = 1
        case down = 2
        
        
        var description: String {
            switch(self) {
            case .happy: return "happy".localized
            case .tired: return "tired".localized
            case .down: return "down".localized
            case .sad: return "sad".localized
            case .excited: return "excited".localized
            case .enthusiastic: return "enthusiastic".localized
            case .loved: return "loved".localized
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
