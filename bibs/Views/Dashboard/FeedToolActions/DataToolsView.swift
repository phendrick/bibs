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
        HStack {
            Text("Data Tools View")
        }.background(Color.pink)
    }
}

struct DataToolsView_Previews: PreviewProvider {
    static var previews: some View {
        DataToolsView()
    }
}
