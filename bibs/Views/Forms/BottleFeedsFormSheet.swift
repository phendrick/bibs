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
                Text("bottle_feed".localized)
                Spacer()
                
                Button("save".localized) {
                    let bottleFeed = BottleFeed(context: self.moc)
                    bottleFeed.amount = Int16(self.feedAmount)
                    bottleFeed.createdAt = Date()
                    bottleFeed.status = self.pickerFeedSource
                    self.profile.parent.activeChild?.addToBottleFeeds(bottleFeed)
                    
                    self.profile.parent.reduceExpressedBottles(self.selectedExpressedBottles, by: Int16(self.feedAmount))
                    
                    do {
                        try self.moc.save()
                        self.profile.objectWillChange.send()
                        self.bottleFeedFormVisible = false
                        self.selectedExpressedBottles = []
                    }catch {
                    }
                }.disabled(self.profile.parent.activeChild == nil)
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
                    .animation(nil)
            }
            
            Form {
                Section(
                    header: Text(String(format: "baby_had".localized, self.profile.parent.activeChild?.wrappedName ?? ""))
                ) {
                    Stepper("\(self.feedAmount)ml", value: self.$feedAmount, in: 0...2000)
                        .padding()
                        .font(.system(.headline, design: .monospaced))
                }
                
                
                Section(
                    header: Text("bottle_feed_type".localized)
                ){
                    VStack {
                        Picker(selection: self.$pickerFeedSource, label: Text("")) {
                            ForEach(BottleFeed.BottleFeedType.allCases, id: \.self) {feedType in
                                Text("\(feedType.description)").tag(feedType.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .animation(nil)
                    
                        
                        if self.pickerFeedSource == .expressedMilk {
                            Section {
                                List {
                                    ForEach(self.expressedBottles, id: \.self) {bottle in
                                        HStack(alignment: .center) {
                                            VStack(alignment: .leading, spacing: 15) {
                                                HStack {
                                                    if bottle.status.emoji != "" {
                                                        Text("\(bottle.status.emoji)")
                                                    }
                                                    
                                                    Text("\(bottle.convertedAmount)").fontWeight(.bold)
                                                }
                                                
                                                Text("\(bottle.wrappedCreatedAt.getFormattedDate())").foregroundColor(.gray)
                                            }.padding([.top, .bottom], 2)

                                            Spacer()
                                            
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(Color(UIColor.systemGreen) )
                                                .opacity(self.selectedExpressedBottles.contains(bottle) ? 1 : 0.2)
                                        }.onTapGesture {
                                            if self.selectedExpressedBottles.contains(bottle) {
                                                self.selectedExpressedBottles.removeAll { (currentBottle) -> Bool in
                                                    currentBottle == bottle
                                                }
                                            }else {
                                                self.selectedExpressedBottles.append(bottle)
                                            }
                                        }
                                    }
                                }
                                .cornerRadius(10)
                                .frame(maxHeight: 200)
                            }.padding([.top, .bottom], 15)
                        }
                    }
                }
            }
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
