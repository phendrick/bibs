//
//  DataRowView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardDataRowView<Content: View>: View {
    let index: Int
    let content: Content
    
//    @State var offset:CGFloat = 50

    init(index: Int, @ViewBuilder content: () -> Content) {
        self.index = index
        self.content = content()
    }
    
    var body: some View {
        self.content
    }
}

struct DataRowView_Previews: PreviewProvider {
    static var previews: some View {
//        DataRowView(index: 0) {
//            Text("OK")
//        }
        DashboardDataRowView(index: 0) {
            Text("OK")
        }
    }
}
