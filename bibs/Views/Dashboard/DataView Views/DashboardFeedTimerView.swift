//
//  DashboardFeedTimerView.swift
//  bibs
//
//  Created by Paul Hendrick on 24/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardFeedTimerView: View {
    var color: Color
    @Binding var expandedLayout: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                if self.expandedLayout {
                    Text("No Active timer").font(.headline)
                }
                
                Text("00:00:00.00")
                    .lineLimit(1).minimumScaleFactor(0.5)
                    .font(.custom("RobotoMono-Regular", size: 30))
                    .padding([.top, .bottom], 5)
                    .foregroundColor(.black)
                    .opacity(0.25)
                
                Text("Feeding from the left side")
                    .font(.subheadline).lineLimit(1).minimumScaleFactor(0.5)
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            }
            .padding([.leading, .trailing])
            .padding([.top, .bottom])
            
            Spacer()
            
            HStack {
                if self.expandedLayout {
                    VStack {
                        HStack {
                            Circle().foregroundColor(.white)
                            .frame(width: 30)
                            .offset(y: 0)
                            .opacity(1)
                            .overlay(
                                Text("L")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .offset(x: 0, y: 0)
                            )
                            
                            Circle().foregroundColor(.white)
                            .frame(width: 15)
                            .offset(y: 10)
                            .opacity(0.25)
                            .overlay(
                                Text("R")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(UIColor.systemBackground))
                                    .offset(x: 0.5, y: 10.5)
                            )
                        }
                    }
                    .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.5, blendDuration: 0.5))
                    .frame(height: 30)
                }
                
                Image(systemName: "pause").frame(width: 30, height: 30)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(self.color)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

struct DashboardFeedTimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardFeedTimerView(
                color: .green, expandedLayout: .constant(false)
            ).previewLayout(.fixed(width: 360, height: 280))
            
            DashboardFeedTimerView(
                color: .green, expandedLayout: .constant(true)
            ).previewLayout(.fixed(width: 360, height: 280))
        }
    }
}
