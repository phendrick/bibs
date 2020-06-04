//
//  SwiftUIView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewSettings: ViewSettings
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to bibs.")
                    .font(.headline)
                
                Text("Ready to get started?")
                    .font(.footnote)
                
                Spacer()
                
                NavigationLink(destination: AddChildView()) {
                    Text("Add your baby")
                }
                
                Text("Feeding for two? If you're co-feeding, you can add another baby later.")
                    .font(.footnote)
                
                Spacer()
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
