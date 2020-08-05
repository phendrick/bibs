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
                    .font(.title)
                
                Spacer()
                
                Image("teddy")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .frame(width: 50, height: 50)
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
