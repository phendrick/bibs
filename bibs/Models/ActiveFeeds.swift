//
//  ActiveFeeds.swift
//  bibs
//
//  Created by Paul Hendrick on 24/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import Combine

struct ActiveFeed {
    let child: Child
}

class ActiveFeeds: ObservableObject {
    @Published var feeds: [ActiveFeed] = []
}
