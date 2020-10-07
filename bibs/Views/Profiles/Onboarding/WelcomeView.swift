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

                Text("ready_to_start".localized)
                    .padding(.bottom, 15)

                NavigationLink(destination: AboutYouView(), isActive: self.$showAddAboutYouView) {
                    EmptyView()
                }
                
                Spacer()
                
                Button("next".localized) {
                }.padding()
                
                Image("bibs")
            }
        }.onTapGesture {
            self.showAddAboutYouView = true
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WelcomeView()
        }
    }
}
