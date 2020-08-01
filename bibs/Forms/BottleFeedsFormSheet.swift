//
//  BottleFeedsFormSheet.swift
//  bibs
//
//  Created by Paul Hendrick on 26/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct BottleFeedsFormSheet: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    @Binding var bottleFeedFormVisible: Bool
    
    @State var pickerFeedType: Int = 0
    @State var pickerFeedSource: BottleFeed.BottleFeedType = .expressedMilk
    @State var feedAmount: Int = 5
    @State var expressedAmount: Int = 0
    @State var selectedExpressedBottles: [ExpressedBottle] = []
    @State var expressedMilkStorage: ExpressedBottle.ExpressedBottleStorageStatus = .refridgerated
    
    @FetchRequest(
        entity: ExpressedBottle.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "state IN %@ AND amount > 0", ExpressedBottle.permittedUsableStates.map{$0.rawValue}),
        animation: Animation.linear.delay(0.5)
    ) var expressedBottles: FetchedResults<ExpressedBottle>
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.bottleFeedFormVisible = false
                }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                }.padding([.top, .trailing], 15)
            }
            
            Text("Bottle Feed").font(.title)
            
            if profile.parent.activeChildrenArray.count > 1 {
                ChildrenFormList()
                    .padding()
            }
            
            Form {
                Section(
                    header: Text("\(self.profile.parent.activeChild?.wrappedName ?? "Child") had")
                ) {
                    Stepper("\(self.feedAmount)ml", value: self.$feedAmount, in: 0...2000)
                        .padding()
                        .font(.custom("RobotoMono-Regular", size: 20))
                }
                
                
                Section(
                    header: Text("Of")
                ){
                    Picker(selection: self.$pickerFeedSource, label: Text("")) {
                        ForEach(BottleFeed.BottleFeedType.allCases, id: \.self) {feedType in
                            Text("\(feedType.description)").tag(feedType.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .animation(nil)
                }
            }
            
//            if self.pickerFeedSource == .expressedMilk {
//                Section {
//                    Text("Choose from stored milk supply").font(.subheadline)
//                    List {
//                        ForEach(self.expressedBottles, id: \.self) {bottle in
//                            HStack {
//                                Text("\(bottle.convertedAmount) ")
//                                Text("\(bottle.wrappedCreatedAt.getFormattedDate())")
//
//                                Spacer()
//
//                                Image(systemName: "checkmark.circle.fill")
//                                    .foregroundColor(Color(UIColor.systemGreen) )
//                                    .opacity(self.selectedExpressedBottles.contains(bottle) ? 1 : 0.2)
//                            }.onTapGesture {
//                                if self.selectedExpressedBottles.contains(bottle) {
//                                    self.selectedExpressedBottles.removeAll { (currentBottle) -> Bool in
//                                        currentBottle == bottle
//                                    }
//                                }else {
//                                    self.selectedExpressedBottles.append(bottle)
//                                }
//                            }
//                        }
//                    }
//                    .cornerRadius(10).padding()
//                    .frame(maxHeight: 200)
//                }
//            }
//
//            Spacer()
            
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
            }
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height/8)
            .background(Color(UIColor.systemBackground))
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor.systemGray6))
    }
}

struct BottleFeedsFormSheet_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return BottleFeedsFormSheet(bottleFeedFormVisible: .constant(true))
            .environment(\.managedObjectContext, context)
            .environmentObject(ProfileObserver.shared)
    }
}
