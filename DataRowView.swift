//
//  DataRowView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DataRowView: View {
    var index: Int
    @State var offset:CGFloat = 30
    
    var body: some View {
        HStack {
            Text("Hello \(index)")
        }
        .offset(x: 0, y: self.offset)
        .opacity(offset == 0 ? 1 : 0)
        .onAppear {
            withAnimation(Animation.spring(response: 0.5, dampingFraction: 0.85, blendDuration: 0.1).delay(0.05 * Double(self.index))) {
                self.offset = 0
            }
        }
        
    }
}

struct DataRowView_Previews: PreviewProvider {
    static var previews: some View {
        DataRowView(index: 0)
    }
}
