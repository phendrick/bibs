//
//  DashboardDataList.swift
//  bibs
//
//  Created by Paul Hendrick on 02/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardDataList<T: NSFetchRequestResult>: View {
    var activeFeedSessions: FetchedResults<T>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct DashboardDataList_Previews: PreviewProvider {
    static var previews: some View {
        DashboardDataList<FeedSession>()
    }
}
