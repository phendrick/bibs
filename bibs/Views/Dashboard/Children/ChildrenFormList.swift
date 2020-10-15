//
//  ChildrenFormList.swift
//  bibs
//
//  Created by Paul Hendrick on 31/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChildrenFormList: View {
    @EnvironmentObject var profile: ProfileObserver
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(profile.parent.activeChildrenArray, id: \.self) {child in
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("\(child.wrappedName)")
                            .font(.callout).fontWeight(self.profile.parent.activeChild == child ? .bold : .none)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color.white)
                        .opacity(self.profile.parent.activeChild == child ? 1 : 0.2)
                }
                .animation(.easeInOut)
                .padding(8)
                .background(Color(child.theme.0))
                .onTapGesture {
                    self.profile.parent.activeChild = child
                    self.profile.objectWillChange.send()
                }
            }
        }
        .cornerRadius(15)
        .animation(nil)
    }
}

struct ChildrenFormList_Previews: PreviewProvider {
    static var previews: some View {
        ChildrenFormList()
    }
}
