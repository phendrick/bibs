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
        entity: FeedSession.entity(),
        sortDescriptors: [],
        animation: .spring()) var bottleFeeds: FetchedResults<BottleFeed>
    
    @State var bottleFeedFormVisible: Bool = false
    
    @State var picker: Int = 0
    @State var feedAmount: Int = 5
    @State var expressedAmount: Int = 0
    
    var body: some View {
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
                    
                Picker(selection: self.$picker, label: Text("")) {
                    Text("I've given a bottle feed").tag(0)
                    Text("I've expressed some milk").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if self.picker == 0 {
                    VStack {
                        Stepper("Milo had \(self.feedAmount)ml", value: self.$feedAmount, in: 0...2000)
                            .padding()
                            .font(.custom("RobotoMono-Regular", size: 20))
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
                        if self.picker == 0 {
                            print(self.feedAmount)
                        }else {
                            print(self.expressedAmount)
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
