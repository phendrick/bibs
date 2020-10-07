//
//  ExpressedMilkSheet.swift
//  bibs
//
//  Created by Paul Hendrick on 27/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ExpressedMilkFormSheet: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    @Binding var expressedMilkFormVisible: Bool
    
    @State var expressedAmount: Int = 0
    @State var expressedMilkStorage: ExpressedBottle.ExpressedBottleStorageStatus = .refridgerated
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("stored_milk".localized)
                Spacer()
                
                Button("save".localized) {
                    let storedMilk = ExpressedBottle(context: self.moc)
                    storedMilk.status = self.expressedMilkStorage
                    storedMilk.amount = Int16(self.expressedAmount)
                    storedMilk.createdAt = Date()
                    
                    do {
                        try self.moc.save()
                        
                        self.profile.objectWillChange.send()
                        self.expressedMilkFormVisible = false
                    }catch {
                    }
                }
            }
            .font(.headline)
            .padding()
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .clipped()
            .shadow(color: .gray, radius: 1, x: 0, y: 0)
            
            Form {
                Section(
                    header: Text("ive_expressed".localized)
                ) {
                    Stepper("\(self.expressedAmount)ml", value: self.$expressedAmount, in: 0...2000).padding()
                }
                
                Section {
                    List {
                        ForEach(ExpressedBottle.ExpressedBottleStorageStatus.allCases, id: \.self) {storage in
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    Text("\(storage.description)").font(.headline).padding(.bottom, 10)
                                    Text("\(storage.details)").font(.subheadline)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(UIColor.systemGreen) )
                                    .opacity(self.expressedMilkStorage == storage ? 1 : 0.2)
                            }
                            .padding(5).tag(storage)
                            .onTapGesture {
                                self.expressedMilkStorage = storage
                            }
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor.systemGray6))
    }
}

struct ExpressedMilkFormSheet_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return ExpressedMilkFormSheet(expressedMilkFormVisible: .constant(true))
            .environment(\.managedObjectContext, context)
            .environmentObject(ProfileObserver.shared)
    }
}
