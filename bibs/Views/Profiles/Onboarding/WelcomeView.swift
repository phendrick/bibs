//
//  SwiftUIView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewSettings: ViewSettings
    @State var showAddAboutYouView: Bool = false
    
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

                NavigationLink(destination: AboutYouView(), isActive: self.$showAddAboutYouView) {
                    EmptyView()
                }
                
                Spacer()
                
                Button("Next") {
                    self.showAddAboutYouView = true
                }.padding()
                
                VStack {
                    HStack {
                        Text("If you're co-feeding you can add another profile later.")
                            .font(.custom("OpenSans-Regular", size: 14))
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
