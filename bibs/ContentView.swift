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
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var viewSettings: ViewSettings
    @FetchRequest(entity: Child.entity(), sortDescriptors: []) var children: FetchedResults<Child>
    
    var body: some View {
        VStack {
            if viewSettings.initialView == .dashboard {
                Text("OK: \(children.count)")
                ActiveFeedsView()
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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return ContentView()
            .environmentObject(ViewSettings(initialView: .dashboard))
            .environment(\.managedObjectContext, context)
    }
}
