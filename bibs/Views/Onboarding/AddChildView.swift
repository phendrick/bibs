//
//  AddChildView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct AddChildView: View {
    @EnvironmentObject var profile: ProfileObserver
    @EnvironmentObject var viewSettings: ViewSettings
    @Environment(\.managedObjectContext) var context
    
    @State var showingImagePicker = false
    @State var inputImage: UIImage?
    @State var image: Image? = Image("baby")
    
    @State var name: String = ""
    @State var dueDate: Date = Date()
    @State var isBorn: Bool = true
    @State var colorScheme: Int16 = 0
    
    @State var showDatePicker: Bool = false
    
    var body: some View {
        return VStack {
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
                                .frame(maxHeight: 200)
//                                .overlay(
//                                    Circle().stroke(
//                                        Child.Themes[self.colorScheme], lineWidth: 6
//                                    )
//                                )
//                                .animation(.linear)
                        }else {
                            VStack {
                                Circle()
                                    .foregroundColor(Color.white)
                                    .frame(width: 200, height: 200)
                                    .overlay(VStack {
                                        ZStack {
                                            Circle().stroke(Color.gray, lineWidth: 2)
                                            Image(systemName: "camera")
                                                .font(.system(size: 40))
                                        }
                                    })
                            }
                        }
                        
                        Spacer()
                    }.padding(.top, 25)
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
                
                
                Section(header: Text("Choose a colour scheme")) {
                    HStack(spacing: 20) {
                        Spacer()
                        
                        ForEach(Child.Themes.keys.sorted(), id: \.self) {index in
                            Rectangle()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Child.Themes[index]?.0)
                                .clipShape(Circle())
                                .onTapGesture {
//                                    self.colorScheme = index
                            }
                        }
                        
                        Spacer()
                    }.offset(x: -15)
                }
            }
            .navigationBarTitle("Welcome, baby")
            .navigationBarItems(trailing: Button(action: save) {
                Text("Done")
            })
        }
    }
    
    func save() {
        let child: Child = self.profile.parent.activeChild ?? self.profile.parent.buildChildObject()
        
        child.wrappedName = self.name
        child.wrappedDueDate = self.dueDate
        child.image = self.inputImage?.pngData()
        child.colorScheme = Int16(self.colorScheme)
        
        do {
            try self.context.save()
            self.profile.parent.setActiveChild(child: child)
            
            self.viewSettings.initialView = .dashboard
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

struct AddChildView_Previews: PreviewProvider {
    static var previews: some View {
        AddChildView()
    }
}
