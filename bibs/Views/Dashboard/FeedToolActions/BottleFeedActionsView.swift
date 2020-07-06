//
//  BottleFeedActionsView.swift
//  bibs
//
//  Created by Paul Hendrick on 06/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct BottleFeedActionsView: View {
    @EnvironmentObject var profile: ProfileObserver
    
    var body: some View {
        HStack {
            Button(action: {
                do {
                    try self.profile.parent.activeChild?.startNewFeedSession()
                }catch {
                }
            }) {
                HStack {
                    Text("Nappy Change")
                    Spacer()
                }.padding()
            }
            
            Button(action: {
                self.profile.parent.activeChild?.clear()
            }) {
                HStack {
                    Text("Clear out")
                    Spacer()
                }.padding()
            }
        }.background(Color.green)
    }
}

struct BottleFeedActionsView_Previews: PreviewProvider {
    static var previews: some View {
        BottleFeedActionsView()
    }
}
