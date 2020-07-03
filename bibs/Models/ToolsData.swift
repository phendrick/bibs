//
//  ToolsData.swift
//  bibs
//
//  Created by Paul Hendrick on 04/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import Combine

struct CardModel: Hashable {
    var image: String
    var title: String
    var subtitle: String
}

let cardData:[CardModel] = [
    CardModel(image: "page1", title: "Feed Timers", subtitle: "Monitor your baby's feeds"),
    CardModel(image: "page2", title: "Nappy Change", subtitle: "Log a wet or dirty nappy"),
    CardModel(image: "page3", title: "Expressed Feed", subtitle: "Given some expressed milk?"),
    CardModel(image: "page4", title: "Data & Progress", subtitle: "Charts & Historical data")
]

class ToolsData: ObservableObject {
    @Published var parent: ParentProfile!
    @Published var data = cardData
}
