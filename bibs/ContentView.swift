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
    
    var body: some View {
        VStack {
            if viewSettings.initialView == .dashboard {
                DashboardView()
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification), perform: { _ in
                        self.profile.parent.suspendActiveFeedSessions(as: .switched)
                    })
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                        self.profile.parent.suspendActiveFeedSessions(as: .card)
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                        self.profile.parent.resumeSuspendedFeedSessions()
                    }
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
