//
//  ChildListSheetView.swift
//  bibs
//
//  Created by Paul Hendrick on 16/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChildListSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profile: ProfileObserver
    
    var children: FetchedResults<Child>
    
    var body: some View {
        ForEach(children) {child in
            VStack {
                Text(child.wrappedName)
                    .onTapGesture {
                        self.profile.parent.setActiveChild(child: child)
                        self.presentationMode.wrappedValue.dismiss()
                }
            }.padding()
        }
    }
}

//struct ChildListSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        return ChildListSheetView(children: [])
//    }
//}
