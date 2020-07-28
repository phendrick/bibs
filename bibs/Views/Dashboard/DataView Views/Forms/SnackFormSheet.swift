//
//  SnackFormSheet.swift
//  bibs
//
//  Created by Paul Hendrick on 27/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct SnackFormSheet: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    @Binding var snackFormVisible: Bool
    
    @State var note: String = ""
    @State var selectedSnackType: Snack.SnackType = .vegetables
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.snackFormVisible = false
                }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                }.padding([.top, .trailing], 15)
            }
            
            Text("Snacks & Solid foods")
                .font(.system(size: 30))
                .padding(.top, 20)
                .padding(.bottom, 80)
            
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
                                    .opacity(self.selectedSnackType == snack ? 1 : 0.2)
                            }
                            .padding(5).tag(snack)
                            .onTapGesture {
                                withAnimation { 
                                    self.selectedSnackType = snack
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
            
            Spacer()
            
            VStack {
                Button("Save") {
                    let snack = Snack(context: self.moc)
                    snack.note = self.note
                    snack.snackType = self.selectedSnackType
                    
                    try? self.moc.save()
                    self.snackFormVisible = false
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height/8)
            .background(Color(UIColor.systemBackground))
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor.systemGray6))
    }
}

struct SnackFormSheet_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return SnackFormSheet(snackFormVisible: .constant(true))
            .environment(\.managedObjectContext, context)
            .environmentObject(ProfileObserver.shared)
    }
}