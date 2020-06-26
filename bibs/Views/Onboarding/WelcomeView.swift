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
                ZStack(alignment: .bottomTrailing) {
                    Text("bibs.")
                        .font(.custom("Pacifico-Regular", size: 150))
                        .foregroundColor(.red)
                }
                
                Text("Ready to get started?")
                    .padding(.bottom, 15)
                
                NavigationLink(destination: AboutYouView()) {
                    Text("Set up a baby profile")
                        .foregroundColor(.orange)
                }
                
                Spacer()
                
                VStack {
                    HStack(alignment: .lastTextBaseline) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.orange)
                            .opacity(0.2)
                        Text("Feeding for two?").padding(.bottom, 10)
                    }
                        
                    HStack {
                        Text("If you're co-feeding you can add another profile later.")
                            .font(.custom("OpenSans-Regular", size: 14))
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
        .font(.custom("OpenSans-Regular", size: 22))
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
