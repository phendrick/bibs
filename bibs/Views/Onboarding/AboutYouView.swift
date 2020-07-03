//
//  AboutYouView.swift
//  bibs
//
//  Created by Paul Hendrick on 26/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct AboutYouView: View {
    @State var name: String = ""
    
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
            }
        }
    }
}

struct AboutYouView_Previews: PreviewProvider {
    static var previews: some View {
        AboutYouView()
    }
}
