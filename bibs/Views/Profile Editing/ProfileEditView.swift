//
//  ProfileEditView.swift
//  bibs
//
//  Created by Paul Hendrick on 01/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ProfileEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var profile: ProfileObserver
    
    @State var showingImagePicker = false
    @State var inputImage: UIImage?
    @State var image: Image?
    @State var name: String = ""
    @State var showAdChildView: Bool = false
    
    var body: some View {
        VStack {
            Form {
                
                Section(header:
                    HStack {
                        Spacer()
                        if image != nil {
                            image?
                                .resizable()
                                .clipShape(Circle())
                                .shadow(radius: 5)
                                .scaledToFit()
                                .frame(maxHeight: 100)
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        }else {
                            VStack {
                                Circle()
                                    .foregroundColor(Color.white)
                                    .frame(width: 100, height: 100)
                                    .overlay(VStack {
                                        ZStack {
                                            Circle().stroke(Color.gray, lineWidth: 2)
                                            Image(systemName: "camera")
                                                .font(.system(size: 40))
                                        }
                                    })
                                    .sheet(isPresented: self.$showingImagePicker, onDismiss: loadImage) {
                                        ImagePicker(image: self.$inputImage)
                                    }
                                    .onTapGesture {
                                        self.showingImagePicker.toggle()
                                    }
                            }
                        }
                        Spacer()
                    }.padding(.top, 25)
                ) {
                    EmptyView()
                }
                
                Section(
                    header: Text("Edit your details")
                ) {
                    TextField("Your name", text: self.$name)
                }
                
                Section(
                    footer: HStack {
                        Image(systemName: "lightbulb")
                        Text("If you're co-feeding, you can add a second profile and easily switch between them, and even set up co-feeding sessions!")
                    }
                ) {
                    List {
                        ForEach(self.profile.parent.childrenArray) {child in
                            NavigationLink(destination: ChildEditView(child: child)) {
                                HStack {
                                    Image(uiImage: child.wrappedImage)
                                        .resizable().frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                    Text("\(child.wrappedName)")
                                }
                            }
                        }
                    }
                    
//                    HStack {
//                        NavigationLink(destination: ChildEditView()) {
//                            Text("Add another")
//                        }
//                    }
                }
            }
        }
        .navigationBarTitle(Text("Update Profile"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: save) {
            Text("Save")
        })
        .onAppear {
            self.name = self.profile.parent.wrappedName
            
            if let _ = self.profile.parent.image {
                self.image = Image(uiImage: self.profile.parent.wrappedImage)
            }
        }
    }
    
    func save() {
        self.profile.parent.createdAt = Date()
        self.profile.parent.name = self.name
        
        if let inputImage = self.inputImage {
            self.profile.parent.image = inputImage.pngData()
        }
        
        do {
            try self.context.save()
            self.showAdChildView = true
            
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

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView()
    }
}
