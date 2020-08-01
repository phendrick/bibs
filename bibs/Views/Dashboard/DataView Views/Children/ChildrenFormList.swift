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
        VStack(alignment: .leading) {
            ForEach(profile.parent.activeChildrenArray, id: \.self) {child in
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("\(child.wrappedName)")
                            .font(self.profile.parent.activeChild == child ? .headline : .subheadline)
                            .font(.system(size: 10))
                            .padding(.bottom, 5)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(UIColor.systemGreen) )
                        .opacity(self.profile.parent.activeChild == child ? 1 : 0.2)
                }
                .onTapGesture {
                    self.profile.parent.activeChild = child
                    self.profile.objectWillChange.send()
                }
            }
        }
    }
}

struct ChildrenFormList_Previews: PreviewProvider {
    static var previews: some View {
        ChildrenFormList()
    }
}
