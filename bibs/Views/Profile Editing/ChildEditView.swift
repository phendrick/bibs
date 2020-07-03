//
//  ChildEditView.swift
//  bibs
//
//  Created by Paul Hendrick on 02/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChildEditView: View {
    @State var name: String = ""
    @State var showDatePicker: Bool = false
    @State var isBorn: Bool = true
    @State var dueDate: Date = Date()
    
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
                
                Section(header: Text("About your baby")) {
                    TextField("Name", text: $name)
                }
                
                Section(header: Text("Due date")) {
                    Toggle(isOn: self.$isBorn) {
                        Text("They're here!")
                    }
                    
                    DatePicker(selection: self.$dueDate) {
                        Text(self.isBorn ? "Date of birth" : "Due date")
                    }
                }
            }
        }
    }
}

struct ChildEditView_Previews: PreviewProvider {
    static var previews: some View {
        ChildEditView()
    }
}
