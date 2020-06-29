//
//  FeedSessionModalView.swift
//  bibs
//
//  Created by Paul Hendrick on 28/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FeedSessionModalView: View {
    @Binding var showingFeedSession: Bool
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct FeedSessionModalView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            FeedSessionModalView(showingFeedSession: .constant(true))
                .previewLayout(.fixed(width: 300, height: 160))
        }
    }
}
