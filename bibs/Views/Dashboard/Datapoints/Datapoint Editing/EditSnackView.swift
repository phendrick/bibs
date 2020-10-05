//
//  EditSnackView.swift
//  bibs
//
//  Created by Paul Hendrick on 09/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct EditSnackView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var profile: ProfileObserver
    @ObservedObject var snack: Snack
    
    @State var snackType: Snack.SnackType = .fruit
    @State var note: String = ""
    
    var body: some View {
        VStack {
            Form {
                Section(
                    header: Text("Snack type")
                ) {
                    List {
                        ForEach(Snack.SnackType.allCases, id: \.self) {snack in
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    Text("\(snack.description)").font(.headline).padding(.bottom, 10)
                                    Text("\(snack.details)").font(.subheadline)
                                }
                                Spacer()
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(UIColor.systemGreen) )
                                    .opacity(self.snackType == snack ? 1 : 0.2)
                            }
                            .padding(5).tag(snack)
                            .onTapGesture {
                                withAnimation {
                                    self.snackType = snack
                                }
                            }
                        }
                    }
                }
                
                Section(
                    header: Text("Add a note eg. \"Carrot sticks\"")
                ) {
                    TextField(self.note, text: self.$note)
                }
            }
        }
        .onAppear {
            self.snackType = self.snack.snackType
            self.note = self.snack.note ?? ""
        }
        .navigationBarItems(trailing: Button("save".localized) {
            self.snack.snackType = self.snackType
            self.snack.note = self.note
            
            do {
                try self.context.save()
                self.profile.objectWillChange.send()
                self.presentationMode.wrappedValue.dismiss()
            }catch {
            }
        })
    }
}

struct EditSnackView_Previews: PreviewProvider {
    static var previews: some View {
        let snack = Snack()
        return EditSnackView(profile: ProfileObserver.shared, snack: snack)
    }
}
