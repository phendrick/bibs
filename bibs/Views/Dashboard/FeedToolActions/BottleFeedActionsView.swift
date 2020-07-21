//
//  BottleFeedActionsView.swift
//  bibs
//
//  Created by Paul Hendrick on 06/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct BottleFeedActionsView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver

    @FetchRequest(
        entity: BottleFeed.entity(),
        sortDescriptors: []) var bottleFeeds: FetchedResults<BottleFeed>
    
    @FetchRequest(
        entity: ExpressedBottle.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(format: "state IN %@ AND amount > 0", ExpressedBottle.permittedUsableStates.map{$0.rawValue}),
        animation: Animation.linear.delay(0.5)
    ) var expressedBottles: FetchedResults<ExpressedBottle>
    
    @State var bottleFeedFormVisible: Bool = false
    
    @State var pickerFeedType: Int = 0
    @State var pickerFeedSource: BottleFeed.BottleFeedType = .expressedMilk
    
    @State var feedAmount: Int = 5
    @State var expressedAmount: Int = 0
    @State var selectedExpressedBottles: [ExpressedBottle] = []
    @State var expressedMilkStorage: ExpressedBottle.ExpressedBottleStorageStatus = .refridgerated
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.bottleFeedFormVisible = true
                }) {
                    HStack {
                        Text("Bottle Feed")
                        Spacer()
                    }.padding()
                }
                
                Spacer()
                
                NavigationLink(destination: BottleFeedsDataView().environment(\.managedObjectContext, self.moc)) {
                    Text("Manage Bottle Feeds")
                }
                
                NavigationLink(destination: ExpressedMilkDataView().environment(\.managedObjectContext, self.moc)) {
                    Text("Manage Expressed Milk")
                }
            }
            .background(Color.green)
        }
        .sheet(isPresented: self.$bottleFeedFormVisible) {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.bottleFeedFormVisible = false
                    }) {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                    }.padding([.top, .trailing], 15)
                }
                
                Text("Bottle feeds")
                    .font(.system(size: 30))
                    .padding(.top, 20)
                    
                Picker(selection: self.$pickerFeedType, label: Text("")) {
                    Text("I've given a bottle feed").tag(0)
                    Text("I've expressed some milk").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if self.pickerFeedType == 0 {
                    VStack {
                        Stepper("\(self.profile.parent.activeChild?.wrappedName ?? "") had \(self.feedAmount)ml", value: self.$feedAmount, in: 0...2000)
                            .padding()
                            .font(.custom("RobotoMono-Regular", size: 20))
                        
                        Text("of")
                        
                        Picker(selection: self.$pickerFeedSource, label: Text("")) {
                            ForEach(BottleFeed.BottleFeedType.allCases, id: \.self) {feedType in
                                Text("\(feedType.description)").tag(feedType.rawValue)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        .animation(nil)
                        
                        if self.pickerFeedSource == .expressedMilk {
                            List {
                                ForEach(self.expressedBottles, id: \.self) {bottle in
                                    HStack {
                                        Text("\(bottle.convertedAmount) ")
                                        Text("\(bottle.wrappedCreatedAt.getFormattedDate())")
                                        
                                        Spacer()
                                        
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(Color( UIColor.tertiaryLabel) )
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
                        }
                    }
                    .background(Color(UIColor.systemBackground))
                }else {
                    VStack {
                        Stepper("I've expressed \(self.expressedAmount)ml", value: self.$expressedAmount, in: 0...2000)
                            .padding()
                            .font(.custom("RobotoMono-Regular", size: 20))
                        
                        Text("Which I'll")
                        
                        Picker(selection: self.$expressedMilkStorage, label: Text("")) {
                            Text("Refridgerate").tag(ExpressedBottle.ExpressedBottleStorageStatus.refridgerated)
                            Text("Freeze").tag(ExpressedBottle.ExpressedBottleStorageStatus.frozen)
                            Text("Use soon").tag(ExpressedBottle.ExpressedBottleStorageStatus.fresh)
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        Picker(selection: self.$expressedMilkStorage, label: Text("")) {
                            Text("Donate").tag(ExpressedBottle.ExpressedBottleStorageStatus.donated)
                            Text("Discard").tag(ExpressedBottle.ExpressedBottleStorageStatus.disposed)
                        }.pickerStyle(SegmentedPickerStyle())
                    }
                    .background(Color(UIColor.systemBackground))
                    Spacer()
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
//                            self.bottleFeedFormVisible = false
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
}

struct BottleFeedActionsView_Previews: PreviewProvider {
    static var previews: some View {
        BottleFeedActionsView()
    }
}
