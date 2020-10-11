//
//  AboutYouView.swift
//  bibs
//
//  Created by Paul Hendrick on 26/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

let nameTranslations = [
    "mum", "mom", "mam", "madre", "mamá"
]

struct AboutYouView: View {
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
                Section(
                    header: Text("your_name".localized),
                    footer: HStack(alignment: .top) {
                        Text("just_call_me".localized)
                        HStack {
                            ForEach(nameTranslations, id: \.self) {name in
                                Button(action: {
                                    self.name = name
                                }) {
                                    Text(name)
                                }
                            }
                        }
                    }
                ) {
                    TextField("your_name", text: self.$name)
                }
            }
            
            // embed the next view in the wizard and set
            // $showAdChildView in the nav button action
            NavigationLink(destination: AddChildView(), isActive: self.$showAdChildView) {
                EmptyView()
            }
        }
        .onAppear(perform: {
            self.name = self.profile.parent.wrappedName
        })
        .navigationBarTitle("about_you".localized)
        .navigationBarItems(trailing: HStack {
            Button(action: save, label: {
                Text("Next")
            }).disabled(self.name.count == 0)
        })
        .navigationBarBackButtonHidden(true)
    }
    
    func save() {
        self.profile.parent.createdAt = Date()
        self.profile.parent.name = self.name
        self.profile.parent.image = self.inputImage?.pngData()

        do {
            try self.context.save()
            
            self.showAdChildView = true
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

struct AboutYouView_Previews: PreviewProvider {
    static var previews: some View {
        AboutYouView()
    }
}
