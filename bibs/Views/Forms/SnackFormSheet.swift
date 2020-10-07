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
                Text("weaning".localized)
                Spacer()
                
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
            }
            .font(.headline)
            .padding()
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .clipped()
            .shadow(color: .gray, radius: 1, x: 0, y: 0)
            
            if profile.parent.activeChildrenArray.count > 1 {
                ChildrenFormList()
                    .padding()
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
                                self.selectedSnackType = snack
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
