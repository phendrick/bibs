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
                Button(action: {
                    self.expressedMilkFormVisible = false
                }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                }.padding([.top, .trailing], 15)
            }
            
            Text("Stored Milk").font(.title)
            
            Form {
                Section(
                    header: Text("I've expressed ")
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
                                withAnimation {
                                    self.expressedMilkStorage = storage
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack {
                Button(action: {
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
                }) {
                    Text("Save")
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

struct ExpressedMilkFormSheet_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return ExpressedMilkFormSheet(expressedMilkFormVisible: .constant(true))
            .environment(\.managedObjectContext, context)
            .environmentObject(ProfileObserver.shared)
    }
}
