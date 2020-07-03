//
//  ProfileEditView.swift
//  bibs
//
//  Created by Paul Hendrick on 01/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ProfileEditView: View {
    @State var name: String = ""
    @State var expressingEnabled: Bool = true
    @State var watchIntegration: Bool = false
    
    @State var babyProfileAlertVisible: Bool = false
    @State var advancedToolsAlertVisible: Bool = false
    
    var body: some View {
        VStack {
            Form {
                
                Section(header:
                    HStack {
                        Spacer()
                        Image("embryo")
                        Spacer()
                    }.padding(.top, 25)
                ) {
                    EmptyView()
                }
                
                Section(header: Text("Edit your details")) {
                    TextField("Your name", text: $name)
                    TextField("Your name", text: $name)
                }
                
                Section(
                    footer: HStack {
                        Image(systemName: "lightbulb")
                        Text("If you're co-feeding, you can add a second profile and easily switch between them, and even set up co-feeding sessions!")
                    }
                ) {
                    List {
                        NavigationLink(destination: ChildEditView()) {
                            HStack {
                                Image(systemName: "heart.fill")
                                Text("Milo")
                            }
                        }
                        
                        NavigationLink(destination: ChildEditView()) {
                            HStack {
                                Image(systemName: "heart")
                                Text("Tabitha")
                            }
                        }
                    }
                    
                    HStack {
                        NavigationLink(destination: ChildEditView()) {
                            Text("Add another")
                        }
                    }
                }
                
//                Section(
//                    header: HStack {
//                        Text("Advanced Tools")
//                        Spacer()
//                        Button(action: {
//                            self.advancedToolsAlertVisible.toggle()
//                        }) {
//                            Image(systemName: "questionmark.circle.fill")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 20, height: 20)
//                        }.alert(isPresented: self.$advancedToolsAlertVisible) { () -> Alert in
//                            Alert(
//                                title: Text("Baby Profiles"),
//                                message: Text("When enabled, additional tools will be made available to allow you to track how much milk you've expressed to store for later"),
//                                dismissButton: .default(Text("OK"))
//                            )
//                        }
//                    }.padding(.top, 25)
//                ) {
//                    Toggle(isOn: self.$watchIntegration) {
//                        Text("Enable hand expressing features")
//                    }
//
////                    Toggle(isOn: self.$expressingEnabled) {
////                        Text("Apple Watch integration")
////                    }
//                }
            }
        }
        .navigationBarTitle(Text("Update Profile"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
        }) {
            Text("Edit")
        })
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
    }
}
