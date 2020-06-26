//
//  AboutYouView.swift
//  bibs
//
//  Created by Paul Hendrick on 26/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct AboutYouView: View {
    var body: some View {
        VStack {
            Text("Some fields about mum")
            
            Divider()
            
            NavigationLink(destination: AddChildView()) {
                Text("Next")
            }
        }
    }
}

struct AboutYouView_Previews: PreviewProvider {
    static var previews: some View {
        AboutYouView()
    }
}
