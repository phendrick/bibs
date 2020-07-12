//
//  DataToolsView.swift
//  bibs
//
//  Created by Paul Hendrick on 06/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DataToolsView: View {
    @EnvironmentObject var profile: ProfileObserver
    
    var body: some View {
        VStack {
            NavigationLink(destination: CalendarView().environmentObject(self.profile)) {
                Text("Feed timer data")
            }
            
            NavigationLink(destination: Text("Data")) {
                Text("Bottle Feeds")
            }
            
            NavigationLink(destination: Text("Data")) {
                Text("Expressed Milk")
            }
            
            NavigationLink(destination: Text("Data")) {
                Text("Nappy Changes")
            }
        }
    }
}

struct DataToolsView_Previews: PreviewProvider {
    static var previews: some View {
        DataToolsView()
    }
}
