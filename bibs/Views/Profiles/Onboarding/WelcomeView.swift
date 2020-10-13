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
                        .font(.custom("Pacifico-Regular", size: 100))
                        .foregroundColor(Color(UIColor(named: "HighlightRed") ?? UIColor.red))
                }

                NavigationLink(destination: AboutYouView(), isActive: self.$showAddAboutYouView) {
                    EmptyView()
                }
                
                Spacer()
                
                Image("bibs")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                
                Button("ready_to_start".localized) {
                    self.showAddAboutYouView = true
                }.padding()
                
                Spacer()
            }
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
