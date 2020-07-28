//
//  DataView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DataView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    @State var expanded: Bool = true
    @State var cofeeding: Bool = false
    @State var timersListVisible: Bool = false
    
    var count: CGFloat = 2
    
    func widthFromGeometry(geometry: GeometryProxy) -> CGFloat {
        let multipler:CGFloat = count > 1 ? 0.9 : 1.0
        return geometry.frame(in: .global).width * multipler
    }
    
    var body: some View {
        ZStack {
            VStack {
                NavigationView {
                    VStack(spacing: 0) {
                        DashboardHeaderView().padding()
                        
                        NavigationLink(destination: Text("OK")) {
                            DashboardHeaderOverviewView().padding([.leading, .trailing])
                        }.foregroundColor(Color(UIColor.label))
                        
                        DashboardToolsListView()
                            .padding(.top, 15)
                        
                        Spacer()

                        DashboardFeedTimerView(
                            color: Color.red, expandedLayout: self.$expanded
                        ).padding([.leading, .trailing])
                        
                        Button(action: {
                            self.timersListVisible.toggle()
                        }) {
                            Text("Show all running timers").padding()
                        }
                    }
                    .navigationBarTitle(Text("Hello"), displayMode: .large)
                }
            }
            
            DashboardPopupTimersListView(visible: $timersListVisible)
                .animation(.spring())
        }
    }
}

struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        DataView()
//            .previewLayout(.fixed(width: 400, height: 800))
    }
}
