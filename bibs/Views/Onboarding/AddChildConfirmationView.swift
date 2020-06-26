//
//  AddChildConfirmationView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct AddChildConfirmationView: View {
    @EnvironmentObject var viewSettings: ViewSettings
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            Text("bibs.")
                .font(.custom("Pacifico-Regular", size: 150))
                .foregroundColor(.red)
            
            Text("That wasn't too bad. Let's get started!")
                .font(.custom("OpenSans-Regular", size: 14))
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                self.viewSettings.initialView = .dashboard
            }) {
                Text("Done")
            }
        }.frame(maxWidth: .infinity)
    }
}

struct AddChildConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        AddChildConfirmationView()
    }
}
