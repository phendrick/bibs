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
    @Environment(\.presentationMode) var presentationMode
    
    @State var showingImagePicker = false
    @State var inputImage: UIImage?
    @State var image: Image?
    
    @State var name: String = ""
    @State var dueDate: Date = Date()
    @State var isBorn: Bool = true
    @State var colorScheme: Int = 0
    
    @State var showDatePicker: Bool = false
    
    var addingChild: Bool = false
    
    var body: some View {
        return VStack {
            Form {
                Section(header: Text("about_your_baby".localized)) {
                    TextField("name".localized, text: self.$name)
                }
                
                Section(header: Text("due_date".localized)) {
                    DatePicker(selection: self.$dueDate, displayedComponents: .date) {
                        Text(self.isBorn ? "date_of_birth".localized : "due_date".localized)
                    }
                }
                
                Section(header: Text("choose_a_theme".localized)) {
                    HStack(spacing: 20) {
                        Spacer()
                        
                        ForEach(Child.Themes.keys.sorted(), id: \.self) {index in
                            Rectangle()
                                .frame(width: self.colorScheme == index ? 40 : 30, height: self.colorScheme == index ? 40 : 30)
                                .foregroundColor(Color(Child.Themes[index]?.0 ?? UIColor.systemFill))
                                .clipShape(Circle())
                                .onTapGesture {
                                    self.colorScheme = index
                            }
                        }
                        
                        Spacer()
                    }
                }.animation(.spring())
            }
            .navigationBarTitle("welcome_baby".localized)
            .navigationBarItems(trailing: HStack {
                Button("done".localized) {
                    self.save(newChild: true)
                }.disabled(self.name.count == 0)
            })
        }
    }
    
    func save(newChild: Bool = false) {
        var child: Child
        
        if newChild || self.profile.parent.activeChild == nil {
            child = self.profile.parent.buildChildObject()
            self.profile.parent.addToChildren(child)
        }else {
            child = self.profile.parent.activeChild!
        }
        
        child.wrappedName = self.name
        child.wrappedDueDate = self.dueDate
        child.colorScheme = Int16(self.colorScheme)
        
        if var inputImage = self.inputImage {
            if inputImage.size.width > 400 || inputImage.size.height > 400 {
                inputImage = inputImage.resize(newSize: CGSize(width: 400, height: 400))
            }

            child.image = inputImage.pngData()
        }
        
        do {
            try self.context.save()
            self.profile.objectWillChange.send()
            self.profile.parent.setActiveChild(child: child)
            
            if addingChild {
                self.presentationMode.wrappedValue.dismiss()
            }else {
                print("Setting initial view to .dashboard")
                self.viewSettings.initialView = .dashboard
            }
        }catch {
            print("Error")
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
