//
//  DashboardPopupTimersListView.swift
//  bibs
//
//  Created by Paul Hendrick on 26/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardPopupTimersListView: View {
    @State var expanded: Bool = false
    @Binding var visible: Bool
    
    @State var backgroundOpacity: CGFloat = 0.75
    @State var dragOffset: CGFloat = 0.0
    
    var body: some View {
        let dragGesture = DragGesture().onChanged { (translation) in
            let offset = abs( translation.location.y - translation.startLocation.y )
            
            self.dragOffset += offset
            
            self.backgroundOpacity -= offset/1000
        }.onEnded { (translation) in
            let offset = abs( translation.location.y - translation.startLocation.y )
            
            if offset > 50 {
                self.visible = false
                self.dragOffset = 0.0
                self.backgroundOpacity = 0.5
            }else {
                self.visible = true
                self.dragOffset = 0.0
                self.backgroundOpacity = 0.5
            }
        }
        
        return VStack {
            Text("Hello")
            Spacer()
            
//            VStack(spacing: 10) {
//                DashboardFeedTimerView(color: Color.red, expandedLayout: self.$expanded)
//                    .padding([.leading, .trailing])
//                
//                DashboardFeedTimerView(color: Color.yellow, expandedLayout: self.$expanded)
//                    .padding([.leading, .trailing])
//            }
//            .padding([.top, .bottom], 25)
//            .edgesIgnoringSafeArea(.all)
//            .background(Color.white)
//            .cornerRadius(15)
//            .offset(y: self.visible ? dragOffset+12 : 4000)
//            .onTapGesture {
//                print("HI")
//            }
//            .animation(.spring())
        }
        .zIndex(self.visible ? 10 : -10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(Double(backgroundOpacity)))
        .edgesIgnoringSafeArea(.all)
        .animation(.linear)
        .gesture(dragGesture)
        .padding(.bottom, 2)
        .onTapGesture {
            self.visible.toggle()
        }
    }
}

struct DashboardPopupTimersListView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardPopupTimersListView(visible: .constant(true))
    }
}
