//
//  EditExpressedMilkView.swift
//  bibs
//
//  Created by Paul Hendrick on 09/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct EditExpressedMilkView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var profile: ProfileObserver
    @ObservedObject var expressedBottle: ExpressedBottle
    
    @State var expressedAmount: Int = 0
    @State var expressedMilkStorage: ExpressedBottle.ExpressedBottleStorageStatus = .refridgerated
    
    var body: some View {
        VStack {
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
            .onAppear(perform: {
                self.expressedAmount = Int(self.expressedBottle.amount)
                self.expressedMilkStorage = self.expressedBottle.status
            })
            .navigationBarTitle("Edit Stored Milk")
            .navigationBarItems(
                trailing: Button(action: {
                    self.expressedBottle.amount = Int16(self.expressedAmount)
                    self.expressedBottle.status = self.expressedMilkStorage
                    
                    do {
                        self.context.refreshAllObjects()
                        try self.context.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }catch {
                        fatalError("Couldn't save")
                    }
                }) {
                    Text("save".localized)
                }
            )
        }
    }
}

struct EditExpressedMilkView_Previews: PreviewProvider {
    static var previews: some View {
        let expressedBottle = ExpressedBottle()
        expressedBottle.amount = 12
        
        return EditExpressedMilkView(profile: ProfileObserver.shared, expressedBottle: expressedBottle)
    }
}
