//
//  ChildTimerCardView.swift
//  bibs
//
//  Created by Paul Hendrick on 15/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChildTimerCardView: View {
    @State var active = false
    
    var width: CGFloat {
        self.active ? 250 : 80
    }
    
    var height: CGFloat {
        self.active ? 140 : 80
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image("baby")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: 80, maxHeight: 80, alignment: .topLeading)
                .clipped()
            
            if self.active {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Paul Hendrick")
                    HStack(spacing: 0) {
                        Text("00:00:00")
                        Text(".00").font(.system(size: 12))
                    }
                }
            }
        }
        .animation(.spring())
        .frame(maxWidth: width, maxHeight: height)
        .background(Color.red)
        .onTapGesture {
            self.active.toggle()
        }
    }
}

struct ChildTimerCardView_Previews: PreviewProvider {
    static var previews: some View {
        ChildTimerCardView()
            .previewLayout(.fixed(width: 400, height: 250))
    }
}
