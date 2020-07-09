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
//                Section(header:
//                    HStack {
//                        Spacer()
//                        if image != nil {
//                            image?
//                                .resizable()
//                                .clipShape(Circle())
//                                .shadow(radius: 5)
//                                .scaledToFit()
//                                .frame(maxHeight: 200)
//                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
//                        }else {
//                            VStack {
//                                Circle()
//                                    .foregroundColor(Color.white)
//                                    .frame(width: 200, height: 200)
//                                    .overlay(VStack {
//                                        ZStack {
//                                            Circle().stroke(Color.gray, lineWidth: 2)
//                                            Image(systemName: "camera")
//                                                .font(.system(size: 40))
//                                        }
//                                    })
//                            }
//                        }
//                        
//                        Spacer()
//                    }.padding(.top, 25)
//                    .sheet(isPresented: self.$showingImagePicker, onDismiss: loadImage) {
//                        ImagePicker(image: self.$inputImage)
//                    }
//                    .onTapGesture {
//                        self.showingImagePicker.toggle()
//                    }
//                ) {
//                    EmptyView()
//                }
                
                Section(
                    header: Text("Edit your details"),
                    footer: HStack(alignment: .top) {
                        Text("Just call me")
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
                    TextField("Your name", text: self.$name)
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
        .navigationBarTitle("About you")
        .navigationBarItems(trailing: Button(action: save) {
            Text("Next")
        })
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
