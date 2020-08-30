//
//  ChartContainer.swift
//  bibs
//
//  Created by Paul Hendrick on 30/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChartContainer: View {
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    BarChartBarView(
                        width: 30,
                        value:  barValue(
                                    value: 50,
                                    maxValue: 100,
                                    chartSize: geometry.frame(in: .global).size.width
                                ),
                        chartSize: geometry.frame(in: .global).size.width,
                        color: Color.green,
                        axis: .horizontal
                    ).onTapGesture {
                        print(geometry)
                    }

                    Text("Chart Label").padding(5).font(.caption)
                }.frame(width: geometry.frame(in: .global).size.width)
            }
        }.frame(maxWidth: .infinity)
    }
}

struct ChartContainer_Previews: PreviewProvider {
    static var previews: some View {
        ChartContainer().previewLayout(.fixed(width: 400, height: 260))
    }
}
