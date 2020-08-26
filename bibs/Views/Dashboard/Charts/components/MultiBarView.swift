//
//  MultiBarView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct MultiBarView: View {
    @State var width: CGFloat = 5
    @State var values: [(CGFloat, Color)]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ForEach(values.sorted { $0.0 > $1.0}, id: \.0) {value in
//                BarChartBarView(width: 5, value: value.0, color: value.1)
                Text("MULTI")
            }
        }
    }
}

struct MultiBarView_Previews: PreviewProvider {
    static var previews: some View {
        let data = [
            (CGFloat(85), Color.red),
            (CGFloat(66), Color.green),
        ]
        return MultiBarView(values: data)
    }
}
