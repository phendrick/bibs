//
//  DashboardToolCardsView.swift
//  bibs
//
//  Created by Paul Hendrick on 03/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardToolCardsView: View {
    var body: some View {
        GeometryReader { outerGeometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    DashboardToolView(
                        cardTitle: "Stored Milk",
                        image: "bottle"
                    )
                        .cornerRadius(5)
                        .frame(width: 160, height: 200)
                        //.overlay(Text("\(-Double(geometry.frame(in: .global).midX - outerGeometry.size.width ))"))
                    
//                    DashboardToolView(cardTitle: "Stored Milk")
//                        .cornerRadius(5)
//                        .frame(width: 160, height: 200)
//
//                    DashboardToolView(cardTitle: "Stored Milk")
//                        .cornerRadius(5)
//                        .frame(width: 160, height: 200)
//
//                    DashboardToolView(cardTitle: "Stored Milk")
//                        .cornerRadius(5)
//                        .frame(width: 160, height: 200)
//
//                    DashboardToolView(cardTitle: "Stored Milk")
//                        .cornerRadius(5)
//                        .frame(width: 160, height: 200)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
    }
}

struct DashboardToolCardsView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardToolCardsView()
    }
}
