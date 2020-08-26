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
    
    var barWidth: CGFloat {
        self.axis == .vertical ? self.width : self.value
    }
    
    var barHeight: CGFloat {
        self.axis == .vertical ? self.value : self.width
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
        .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.5, blendDuration: 0.5))
        .cornerRadius(5)
    }
}

//struct BarChartBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            BarChartBarView(width: 10, value: 50, maxValue: 100, color: .red)
//                .previewLayout(.fixed(width: 400, height: 200)).animation(.spring())
//            
//            BarChartBarView(width: 10, value: 50, maxValue: 100, color: .red, axis: .horizontal)
//                .previewLayout(.fixed(width: 400, height: 200))
//            
//        }
//    }
//}
