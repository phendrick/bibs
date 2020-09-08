//
//  DashboardToolView.swift
//  bibs
//
//  Created by Paul Hendrick on 03/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct MiniChart: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(1...5, id: \.self) { number in
                Rectangle()
                    .frame(width: 5, height: CGFloat.random(in: 10...40))
                    .foregroundColor(.white)
                .cornerRadius(5)
            }
        }
    }
}

struct DashboardToolView: View {
    var cardTitle: String
    var image: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text(self.cardTitle).font(.footnote)
                Image(self.image).resizable().frame(width: 80, height: 80)
                
                Spacer()
                
                MiniChart()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .foregroundColor(.white)
        }
        .frame(width: 160, height: 200, alignment: .leading).background(Color.green)
    }
}

struct DashboardToolView_Previews: PreviewProvider {
    static var previews: some View {
        return GeometryReader { geometry in
            DashboardToolView(
                cardTitle: "Hello There",
                image: "bottle"
            ).padding(40)
        }
    }
}
