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
        sortDescriptors: []) var expressedBottles: FetchedResults<ExpressedBottle>
    
    @State var bottleFeedFormVisible: Bool = false
    
    @State var pickerFeedType: Int = 0
    @State var pickerFeedSource: Int = 0
    
    @State var feedAmount: Int = 5
    @State var expressedAmount: Int = 0
    
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
            }
            .background(Color.green)
            
            Divider()
            
            VStack {
                ForEach(bottleFeeds, id: \.self) {feed in
                    Text("Feed: \(feed.amount)")
                }
            }
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
                
                Image(systemName: "ear")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 180)
                    .padding(.top, 80)
                    
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
                        Stepper("Milo had \(self.feedAmount)ml", value: self.$feedAmount, in: 0...2000)
                            .padding()
                            .font(.custom("RobotoMono-Regular", size: 20))
                        Text("of")
                        Picker(selection: self.$pickerFeedSource, label: Text("")) {
                            ForEach(BottleFeed.BottleFeedType.allCases, id: \.self) {feedType in
                                Text("\(feedType.description)").tag(feedType.rawValue)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        .animation(nil)
                        
                        if self.pickerFeedSource == 0 {
                            List {
                                ForEach(0..<5, id: \.self) {id in
                                    Text("Bottle \(id)")
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
                    }
                    .background(Color(UIColor.systemBackground))
                }
                
                Spacer()
                
                VStack {
                    Button(action: {
                        if self.pickerFeedType == 0 {
                            let bottleFeed = BottleFeed(context: self.moc)
                            bottleFeed.amount = Int16(self.feedAmount)
                            bottleFeed.createdAt = Date()
                            self.profile.parent.activeChild?.addToBottleFeeds(bottleFeed)
                        }else {
                            let expressedBottle = ExpressedBottle(context: self.moc)
                            expressedBottle.status = .fresh
                            expressedBottle.amount = Int16(self.expressedAmount)
                            expressedBottle.createdAt = Date()
                            self.profile.parent.addToExpressedBottles(expressedBottle)
                        }
                        
                        do {
                            try self.moc.save()
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
