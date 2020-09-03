//
//  BarView.swift
//  bibs
//
//  Created by Paul Hendrick on 17/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct MultiBarChartBarView: View {
    var width: CGFloat = 0
    var values: [(value: CGFloat, color: Color)] = [
        (value: 10, color: .red), (value: 20, color: .orange), (value: 5, color: .yellow), (value: 13, color: .blue),
    ]
    var chartSize: CGFloat = 0
    var color: Color = .white
    var axis: Axis.Set = .vertical
    var cornerRadius: CGFloat = 5
    
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
        
        return ZStack(alignment: self.axis == .vertical ? .bottom : .leading) {
            Rectangle()
                .frame(width: backgroundWidth, height: backgroundHeight)
                .foregroundColor(color)
                .opacity(0.25)
                .animation(nil)
                .cornerRadius(self.cornerRadius)
            
            
//            ForEach(self.values, id: \.self) { value in
//                Rectangle()
//                    .foregroundColor(value.color)
//                    .frame(width: barWidth(value), height: barHeight)
//                    .opacity(1)
//                    .cornerRadius(self.cornerRadius)
//            }
        }
        .onTapGesture {
            print(self.backgroundHeight, self.barValue)
        }
//        .animation(.easeOut(duration: Double( self.value / self.chartSize )))
    }
}
