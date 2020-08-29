//
//  BarView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct BarChartBarView: View {
    var width: CGFloat = 0
    var value: CGFloat = 0
    var chartHeight: CGFloat = 0
    var color: Color = .white
    var axis: Axis.Set = .vertical
    
    @State var barValue: CGFloat = 0
    
    var barWidth: CGFloat {
        self.axis == .vertical ? self.width : self.barValue
    }
    
    var barHeight: CGFloat {
        self.axis == .vertical ? self.barValue : self.width
    }
    
    var backgroundWidth: CGFloat {
        self.axis == .vertical ? self.width : self.chartHeight
    }
    
    var backgroundHeight: CGFloat {
        self.axis == .vertical ? self.chartHeight : self.width
    }
    
    var body: some View {
        ZStack(alignment: self.axis == .vertical ? .bottom : .leading) {
            Rectangle()
                .frame(width: backgroundWidth, height: backgroundHeight)
                .foregroundColor(.white)
                .opacity(0.25)

            Rectangle()
                .foregroundColor(color)
                .frame(width: barWidth, height: barHeight)
                .opacity(1)
        }
        .onAppear {
            self.barValue = self.value
        }
        .animation(.easeOut(duration: Double( self.chartHeight / self.value )))
    }
}
