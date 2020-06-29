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
    @EnvironmentObject var viewSettings: ViewSettings
    
    var body: some View {
        VStack {
            if viewSettings.initialView == .dashboard {
//                DashboardView(
//                    viewSettings: <#T##ViewSettings#>,
//                    activeFeedTool: <#T##FeedTool#>,
//                    showingFeedSession: <#T##Bool#>
//                )
//                .environmentObject(ActiveChildProfile.shared)
//                .environment(\.managedObjectContext, context)

//                DashboardView()
                DashboardView()
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
            .environmentObject(ViewSettings(initialView: .dashboard))
    }
}
