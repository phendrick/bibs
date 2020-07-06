//
//  ContentView.swift
//  bibs
//
//  Created by Paul Hendrick on 22/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var profile: ProfileObserver
    @EnvironmentObject var viewSettings: ViewSettings
    
    @State var showingTimerAlert = false
    
    var body: some View {
        VStack {
            if viewSettings.initialView == .dashboard {
                DashboardView()
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification), perform: { _ in
                        self.profile.parent.suspendActiveFeedSessions(as: .terminated)
                    })
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                        self.profile.parent.suspendActiveFeedSessions(as: .switched)
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                        self.profile.parent.resumeSuspendedFeedSessions()
//                        if self.profile.parent.timerDriftWithinPermittedRange {
//                            self.profile.parent.resumeSuspendedFeedSessions()
//                        }else {
//                            self.showingTimerAlert = true
//                        }
                    }
//                    .alert(isPresented: self.$showingTimerAlert) {
//                        Alert(
//                            title: Text("Timer"),
//                            message: Text("Resume timer"),
//                            primaryButton: .default(Text("Yes"), action: {
//                                self.profile.parent.resumeSuspendedFeedSessions()
//                            }),
//                            secondaryButton: .cancel({
//                                self.profile.parent.suspendedFeedSessions.map{$0.pause()}
//                            })
//                        )
//                    }
            }else {
                WelcomeView()
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView()
            .environmentObject(ParentProfile())
            .environmentObject(ViewSettings(initialView: .dashboard))
    }
}
