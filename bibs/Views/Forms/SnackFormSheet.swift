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
            
            Text("weaning".localized).font(.headline)
            
            if profile.parent.activeChildrenArray.count > 1 {
                ChildrenFormList()
                    .padding()
                    .animation(nil)
            }
            
            Form {
                Section(
                    header: Text("weaning_type")
                ) {
                    List {
                        ForEach(Snack.SnackType.allCases, id: \.self) {snack in
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    Text("\(snack.description)").font(.headline).padding(.bottom, 10)
                                    Text("\(snack.details)").font(.caption)
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
                    header: Text("weaning_note_hint".localized)
                ) {
                    TextField(self.note, text: self.$note)
                }
            }
            
            Spacer()
            
            VStack {
                Button("save".localized) {
                    guard let child = self.profile.parent.activeChild else {
                        debugPrint("No activeChild")
                        return
                    }
                    
                    let snack = Snack(context: self.moc)
                    snack.note = self.note
                    snack.snackType = self.selectedSnackType
                    snack.createdAt = Date()
                    child.addToSnacks(snack)
                    
                    try? self.moc.save()
                    self.snackFormVisible = false
                    self.profile.objectWillChange.send()
                }
                .font(.headline)
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
