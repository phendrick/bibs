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
    
    @State var pickerFeedType: Int = 0
    @State var pickerFeedSource: BottleFeed.BottleFeedType = .expressedMilk
    @State var feedAmount: Int = 5
    @State var expressedAmount: Int = 0
    @State var selectedExpressedBottles: [ExpressedBottle] = []
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
            
            Text("Expressing").font(.title)
            
            Form {
                Section(
                    header: Text("I've expressed ")
                ) {
                    Stepper("\(self.expressedAmount)ml", value: self.$expressedAmount, in: 0...2000).padding()
                }
                
                Section(
                    header: Text("Which I'll")
                ) {
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
                    if self.pickerFeedType == 0 {
                        let bottleFeed = BottleFeed(context: self.moc)
                        bottleFeed.amount = Int16(self.feedAmount)
                        bottleFeed.createdAt = Date()
                        bottleFeed.status = self.pickerFeedSource
                        self.profile.parent.activeChild?.addToBottleFeeds(bottleFeed)
                        
                        self.profile.parent.reduceExpressedBottles(self.selectedExpressedBottles, by: Int16(self.feedAmount))
                    }else {
                        let expressedBottle = ExpressedBottle(context: self.moc)
                        expressedBottle.status = .fresh
                        expressedBottle.amount = Int16(self.expressedAmount)
                        expressedBottle.createdAt = Date()
                        self.profile.parent.addToExpressedBottles(expressedBottle)
                    }
                    
                    do {
                        try self.moc.save()
                        
                        self.selectedExpressedBottles = []
                    }catch {
                    }
                }) {
                    Text("OK")
                }
                
                Spacer()
            }
            Spacer()
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
