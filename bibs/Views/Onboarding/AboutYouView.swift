//
//  AboutYouView.swift
//  bibs
//
//  Created by Paul Hendrick on 26/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct AboutYouView: View {
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var profile: ProfileObserver
    
    @State var name: String = ""
    @State var showAdChildView: Bool = false
    
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
                    TextField("Your name", text: self.$name)
                }
            }
            
            // embed the next view in the wizard and set $showAdChildView in the button action
            NavigationLink(destination: AddChildView(), isActive: self.$showAdChildView) {
                EmptyView()
            }
            
        }
        .navigationBarItems(trailing: Button(action: {
            self.profile.parent.createdAt = Date()
            self.profile.parent.name = self.name
            
            do {
                try self.context.save()
                
                self.showAdChildView = true
            }catch {
                debugPrint(error)
            }
        }) {
            Text("Next")
        }).onAppear {
            self.name = self.profile.parent.wrappedName
        }
    }
}

struct AboutYouView_Previews: PreviewProvider {
    static var previews: some View {
        AboutYouView()
    }
}
