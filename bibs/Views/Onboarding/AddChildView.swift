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
            ChildEditView()
            
            VStack {
                Button(action: {
                    let child = Child(context: self.moc)
                    
                    if let data = self.uiImage.pngData() {
                        child.image = data
                    }
                    
                    child.wrappedName = self.name
                    child.wrappedDueDate = self.dueDate
                    child.createdAt = Date()
                    
                    do {
                        print("Saving...")
                        try self.moc.save()
                    }catch {
                        print("Error: \(error)")
                    }
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
