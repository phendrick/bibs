//
//  DashboardHeaderView.swift
//  bibs
//
//  Created by Paul Hendrick on 24/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardHeaderView: View {
    @EnvironmentObject var profile: ProfileObserver
    @State var childListSheetVisible: Bool = false
    
    var body: some View {
        ZStack {
            HStack(alignment: .center) {
                Text("How are you today?")
                    .font(.title).padding(.top, 5)
                
                Spacer()
                
                Image("teddy")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(maxHeight: 100)
                    .onTapGesture {
//                        if self.profile.parent.childrenArray.count < 2 {
//                            return
//                        }
                        
                        self.childListSheetVisible.toggle()
                    }
                    .sheet(isPresented: self.$childListSheetVisible) {
                        ChildrenListSheet(childrenSheetVisible: self.$childListSheetVisible)
                            .environmentObject(self.profile)
                    }
            }
        }
    }
}

struct DashboardHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardHeaderView()
            //.previewLayout(.fixed(width: 360, height: 300))
    }
}
