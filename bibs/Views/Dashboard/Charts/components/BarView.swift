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
    var chartSize: CGFloat = 0
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
        return self.axis == .vertical ? self.width : self.chartSize
    }
    
    var backgroundHeight: CGFloat {
        self.axis == .vertical ? self.chartSize : self.width
    }
    
    var body: some View {
        ZStack(alignment: self.axis == .vertical ? .bottom : .leading) {
            Rectangle()
                .frame(width: backgroundWidth, height: backgroundHeight)
                .foregroundColor(color)
                .opacity(0.25)
                .animation(nil)

            Rectangle()
                .foregroundColor(color)
                .frame(width: barWidth, height: barHeight)
                .opacity(1)
        }.onAppear {
            self.barValue = self.value
        }
        .onTapGesture {
            print(self.backgroundHeight, self.barValue)
        }
        .animation(.easeOut(duration: Double( self.value / self.chartSize )))
    }
}
