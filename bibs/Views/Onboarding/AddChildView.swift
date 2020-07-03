//
//  AddChildView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct AddChildView: View {
    @State var imagePickerIsVisible = false
    @State var selectedImage = UIImage()
    
    @EnvironmentObject var profile: ProfileObserver
    @EnvironmentObject var viewSettings: ViewSettings
    @Environment(\.managedObjectContext) var context
    
    @State var name: String = ""
    @State var dueDate: Date = Date()
    @State var isBorn: Bool = true
    
    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false
    @State var uiImage: UIImage = UIImage()
    
    @State var showDatePicker: Bool = false
    
    var body: some View {
        return VStack {
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
                    TextField("Name", text: self.$name)
                }
                
                Section(header: Text("Due date")) {
                    Toggle(isOn: self.$isBorn) {
                        Text("They're here!")
                    }
                    
                    DatePicker(selection: self.$dueDate) {
                        Text(self.isBorn ? "Date of birth" : "Due date")
                    }
                }
                
                Button(action: {
                    self.viewSettings.initialView = .dashboard
                }) {
                    Text("OK")
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
//            VStack {
//                EmptyView()
//            }
//            .navigationBarItems(trailing: Button(action: {
//                let child: Child = self.profile.parent.activeChild ?? self.profile.parent.buildChildObject()
//
//                child.wrappedName = self.name
//                child.wrappedDueDate = self.dueDate
//
//                if let data = self.uiImage.pngData() {
//                    child.image = data
//                }
//
//                do {
//                    try self.context.save()
//
//                    self.profile.parent.setActiveChild(child: child)
//
//                    withAnimation {
//                        self.viewSettings.initialView = .dashboard
//                    }
//                }catch {}
//            }) {
//                Text("Done")
//            }).onAppear {
//                self.name = self.profile.parent.activeChild?.wrappedName ?? ""
//            }
        }
    }
}

struct AddChildView_Previews: PreviewProvider {
    static var previews: some View {
        AddChildView()
    }
}
