//
//  NappyChangeCalendarRowView.swift
//  bibs
//
//  Created by Paul Hendrick on 16/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct NappyChangeCalendarRowView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("nappy")
            Text("\(Date().description)")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

struct NappyChangeCalendarRowView_Previews: PreviewProvider {
    static var previews: some View {
        NappyChangeCalendarRowView()
    }
}
