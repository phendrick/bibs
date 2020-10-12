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
    var cornerRadius: CGFloat = 5
    
    @State var barValue: CGFloat = 0
    var showLabel: Bool = false
    var label: String?
    
    var labelColor: Color = .gray
    
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
    
    var labelOffset: CGSize {
        if self.axis == .vertical {
            return CGSize(width: 0, height: (backgroundHeight/2)+10)
        }else {
            return CGSize(width: 5, height: 0)
        }
    }
    
    var valueLabel: String {
        self.label ?? "\(self.value)"
    }
    
    var valueLabelColor: Color {
        self.axis == .vertical ? .white : self.labelColor
    }
    
    @ViewBuilder func labelForChartValue(label: String) -> some View {
        self.showLabel ? Text(label) : Text("")
    }
    
    var body: some View {
        ZStack(alignment: self.axis == .vertical ? .bottom : .leading) {
            Rectangle()
                .frame(width: backgroundWidth, height: backgroundHeight)
                .foregroundColor(color)
                .opacity(0.25)
                .animation(nil)
                .cornerRadius(self.cornerRadius)
            
            Rectangle()
                .foregroundColor(color)
                .frame(width: barWidth, height: barHeight)
                .opacity(1)
                .cornerRadius(self.cornerRadius)
                .animation(.easeOut(duration: Double( self.value / self.chartSize )))
            
//            if self.showLabel {
//                Text(self.valueLabel)
//                    .foregroundColor(valueLabelColor)
//                    .offset(labelOffset)
//                    .font(.custom("RobotoMono-Regular", size: 12))
//            }
            
        }
        .overlay(
            labelForChartValue(label: self.valueLabel)
                .offset(labelOffset)
                .fixedSize()
                .font(.custom("RobotoMono-Regular", size: 12))
                .frame(alignment: .bottom)
        )
        .onAppear {
            self.barValue = self.value
        }
    }
}
