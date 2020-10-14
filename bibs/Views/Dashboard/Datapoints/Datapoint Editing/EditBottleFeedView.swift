//
//  EditBottleFeedView.swift
//  bibs
//
//  Created by Paul Hendrick on 09/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct EditBottleFeedView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var profile: ProfileObserver
    @ObservedObject var bottleFeed: BottleFeed
    
    @State var feedAmount: Int = 5
    @State var pickerFeedSource: BottleFeed.BottleFeedType = .expressedMilk
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Stepper("\(self.feedAmount)ml", value: self.$feedAmount, in: 0...2000)
                        .padding()
                        .font(.system(.headline, design: .monospaced))
                }
            }.background(Color.green)
        }
        .background(Color(UIColor.systemGray6))
        .onAppear(perform: {
            self.feedAmount = Int(self.bottleFeed.amount)
        })
        .navigationBarItems(trailing: Button("save".localized) {
            self.bottleFeed.amount = Int16(self.feedAmount)
            
            do {
                try self.context.save()
                self.profile.objectWillChange.send()
                self.presentationMode.wrappedValue.dismiss()
            }catch {
            }
        })
    }
}

struct EditBottleFeedView_Previews: PreviewProvider {
    static var previews: some View {
        let bottleFeed = BottleFeed()
        return EditBottleFeedView(profile: ProfileObserver.shared, bottleFeed: bottleFeed)
    }
}
