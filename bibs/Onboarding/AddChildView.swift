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
    
    @Environment(\.managedObjectContext) var moc
    
    @State var name: String = ""
    @State var dueDate: Date = Date()
    @State var isBorn: Bool = true
    
    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false
    @State var uiImage: UIImage = UIImage()
    
    @State var showDatePicker: Bool = false
    
    var body: some View {
        return VStack {
            HStack {
                Image(uiImage: self.uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 120, height: 120)
            }
            
            VStack {
                TextField("Name", text: self.$name)
                
                Image(systemName: "photo")
                    .onTapGesture {
                        self.showImagePicker.toggle()
                }
            }.sheet(isPresented: $showImagePicker, onDismiss: {
                self.showImagePicker = false
            }) {
                ImagePickerViewController(isPresented: self.$showImagePicker, selectedImage: self.$uiImage)
            }
            
            VStack {
                Text("\(self.$dueDate.wrappedValue)")
                    .onTapGesture {
                        self.showDatePicker.toggle()
                }
                
                Toggle("They've arrived", isOn: self.$isBorn)
                
            }.sheet(isPresented: $showDatePicker) {
                DatePicker(selection: self.$dueDate) {
                    Text("Due Date")
                }.labelsHidden()
            }
            
            Text("If your little one was early...something something something")
            
            Spacer()
            
            VStack {
                Button(action: {
//                    let child = Child(context: self.moc)
//                    
//                    if let data = self.uiImage.pngData() {
//                        child.image = data
//                    }
//                    
//                    child.wrappedName = self.name
//                    child.wrappedDueDate = self.dueDate
//                    child.createdAt = Date()
//                    
//                    do {
//                        print("Saving...")
//                        try self.moc.save()
//                    }catch {
//                        print("Error: \(error)")
//                    }
                }) {
                    Text("Save")
                }
                
                Divider()
                
                NavigationLink(destination: AddChildConfirmationView()) {
                    Text("Next")
                }
            }
        }
    }
}

struct AddChildView_Previews: PreviewProvider {
    static var previews: some View {
        AddChildView()
    }
}
