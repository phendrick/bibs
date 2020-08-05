//
//  FeedSessionCalendarRowView.swift
//  bibs
//
//  Created by Paul Hendrick on 16/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FeedSessionCalendarRowView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("bottle")
            Text("\(Date().description)")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

struct FeedSessionCalendarRowView_Previews: PreviewProvider {
    static var previews: some View {
        FeedSessionCalendarRowView()
    }
}
