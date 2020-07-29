//
//  DataView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DataView: View {
    @ObservedObject var profile: ProfileObserver
    
    @Environment(\.managedObjectContext) var moc
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

                        if self.profile.parent.activeChild != nil && self.profile.parent.activeChild!.activeFeedSession != nil{
                            DashboardFeedTimerView(
                                profile: self.profile,
                                feedSession: self.profile.parent.activeChild!.activeFeedSession!,
                                color: Color.red,
                                expandedLayout: self.$expanded
                            ).padding([.leading, .trailing])
                            
                            Button(action: {
                                print(self.profile.parent.activeChild?.activeFeedSession)
                                self.timersListVisible.toggle()
                            }) {
                                Text("Show all running timers").padding()
                            }
                            
                            
                            Text("Something").onTapGesture {
                                print(self.profile.parent.activeChild!.activeFeedSession)
                            }
                            
                        }else {
                            Button("Start a timer") {
                                withAnimation {
                                    try? self.profile.parent.activeChild?.startNewFeedSession()
                                    self.profile.objectWillChange.send()
                                }
                            }
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
        DataView(profile: ProfileObserver.shared)
//            .previewLayout(.fixed(width: 400, height: 800))
    }
}
