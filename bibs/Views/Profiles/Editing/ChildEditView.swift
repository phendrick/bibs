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
    @State var childStatus: Child.ChildStatuses = .current
    
    @State var routineSheetVisible: Bool = false
    
    var getTheme: Theme {
        guard let theme = Child.Themes[self.colorScheme] else {
            return Child.Themes[0]!
        }
        
        return theme
    }
    
    var body: some View {
        Form {
            Section(header: Text("about_your_baby".localized)) {
                TextField("name".localized, text: $name)
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
                }.animation(.spring())
            }
            
            Section(header: Text("is_currently".localized)) {
                List {
                    ForEach(Child.ChildStatuses.allCases, id: \.self) { status in
                        HStack {
                            Button(status.editDescription) {
                            }
                            
                            Spacer()
                            
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color(UIColor.systemGreen))
                                .opacity(self.childStatus == status ? 1 : 0.2)
                        }.onTapGesture {
                            self.childStatus = status
                        }
                    }
                }
            }
            
            Section {
                Button("manage_routine".localized) {
                    self.routineSheetVisible.toggle()
                }
            }
        }
        .navigationBarItems(trailing:
            HStack {
                Button("done".localized) {
                    save()
                }
                .disabled(self.name.count == 0)
            }
        )
        .onAppear {
            self.name = self.child.wrappedName
            
            if let _ = self.child.image {
                self.image = Image(uiImage: self.child.wrappedImage)
            }
            self.childStatus = self.child.status
            self.isBorn = self.child.isBorn
            self.colorScheme = Int(self.child.colorScheme)
            self.dueDate = self.child.dueDate ?? Date()
        }.sheet(isPresented: self.$routineSheetVisible) {
            ChildRoutineView()
        }
    }
    
    func save() {
        if self.child.objectID.persistentStore == nil {
            self.child.wrappedCreatedAt = Date()
            self.profile.parent.addToChildren(child)
        }

        self.child.status = self.childStatus
        self.child.wrappedName = self.name
        self.child.colorScheme = Int16(self.colorScheme)
        self.child.isBorn = self.isBorn

        if var inputImage = self.inputImage {
            if inputImage.size.width > 400 || inputImage.size.height > 400 {
                inputImage = inputImage.resize(newSize: CGSize(width: 400, height: 400))
            }

            self.child.image = inputImage.pngData()
        }
        
        do {
            try self.context.save()

            self.profile.objectWillChange.send()
            self.profile.parent.objectWillChange.send()
            
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
