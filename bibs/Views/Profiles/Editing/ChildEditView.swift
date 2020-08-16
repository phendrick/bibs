//
//  ChildEditView.swift
//  bibs
//
//  Created by Paul Hendrick on 02/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct ChildEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var profile: ProfileObserver
    
    var child: Child
    
    @State var showingImagePicker = false
    @State var inputImage: UIImage?
    
    @State var image: Image?
    @State var name: String = ""
    @State var showDatePicker: Bool = false
    @State var isBorn: Bool = true
    @State var dueDate: Date = Date()
    @State var colorScheme: Int = 0
    
    var body: some View {
        VStack {
            Form {
                Section(header:
                    HStack {
                        if image != nil {
                            Spacer()
                            AvatarImageView(image: image, color:Child.Themes[self.colorScheme]!.0, layout: .expanded)
                                .animation(.linear)
                            Spacer()
                        }else {
                            VStack {
                                Circle()
                                    .opacity(0.2)
                                    .foregroundColor(child.theme.0)
                                    .frame(width: 200, height: 200)
                                    .overlay(VStack {
                                        ZStack {
                                            Circle()
                                                .stroke(
                                                    Child.Themes[self.colorScheme]!.0, lineWidth: 6
                                                )
                                                .foregroundColor(.black)
                                            Image(systemName: "camera")
                                                .font(.system(size: 40))
                                        }
                                    })
                                    .animation(.linear)
                            }
                        }
                    }
                    .padding(.top, 25)
                    .sheet(isPresented: self.$showingImagePicker, onDismiss: loadImage) {
                        ImagePicker(image: self.$inputImage)
                    }
                    .onTapGesture {
                        self.showingImagePicker.toggle()
                    }
                ) {
                    EmptyView()
                }
                
                Section(header: Text("About your baby")) {
                    TextField("Name", text: $name)
                }
                
                Section(header: Text("Due date")) {
                    DatePicker(selection: self.$dueDate) {
                        Text(self.isBorn ? "Date of birth" : "Due date")
                    }
                }
                
                Section(header: Text("Choose a colour scheme")) {
                    HStack(spacing: 20) {
                        Spacer()

                        ForEach(Child.Themes.keys.sorted(), id: \.self) {index in
                            Rectangle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Child.Themes[index]?.0)
                                .clipShape(Circle())
                                .onTapGesture {
                                    self.colorScheme = index
                            }
                        }

                        Spacer()
                    }.offset(x: -15)
                }
            }
        }
        .navigationBarTitle("\(child.wrappedName)")
        .navigationBarItems(trailing: Button(action: save) {
            Text("Done")
        })
        .onAppear {
            self.name = self.child.wrappedName
            
            if let _ = self.child.image {
                self.image = Image(uiImage: self.child.wrappedImage)
            }
            
            self.isBorn = self.child.isBorn
            self.colorScheme = Int(self.child.colorScheme)
            self.dueDate = self.child.dueDate ?? Date()
        }
    }
    
    func save() {
        guard self.name != "" else {
            print("Returning...")
            return
        }
        
        if self.child.objectID.persistentStore == nil {
            print("Adding new child to parent")
            self.child.wrappedCreatedAt = Date()
            self.profile.parent.addToChildren(child)
        }
        
        self.child.wrappedName = self.name
        self.child.colorScheme = Int16(self.colorScheme)
        self.child.isBorn = self.isBorn
        
//        if var inputImage = self.inputImage {
//            if inputImage.size.width > 400 || inputImage.size.height > 400 {
//                inputImage = inputImage.resize(newSize: CGSize(width: 400, height: 400))
//            }
//
//            self.child.image = inputImage.pngData()
//        }
        
        do {
            try self.context.save()
            
            self.profile.objectWillChange.send()
            print("Saved \(self.presentationMode.wrappedValue)")
            self.presentationMode.wrappedValue.dismiss()
        }catch {
            debugPrint(error)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
        
        image = Image(uiImage: inputImage)
    }
}

struct ChildEditView_Previews: PreviewProvider {
    static var previews: some View {
        let context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        let child = Child(context: context)
        
        return ChildEditView(child: child)
    }
}
