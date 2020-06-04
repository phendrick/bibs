//
//  ActiveFeedList.swift
//  bibs
//
//  Created by Paul Hendrick on 24/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ActiveFeedView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 20) {
                Image("tabby")
                    .resizable()
                    .frame(width: 50, height: 48)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Tabitha")
                        .font(.headline)
                    Text("This is tabitha's 8th feed today")
                        .font(.footnote)
                        .lineLimit(1)
                }
                
                VStack(spacing: 10) {
                    Text("00:12:32")
                        .font(.headline)
                    
                    Button(action: {
                    }) {
                        Text("Details")
                            .font(.footnote)
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .padding([.top, .bottom], 5)
                            .padding([.leading, .trailing], 10)
                    }.background(Capsule().foregroundColor(.orange))
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .padding()
    }
}

struct ActiveFeedList_Previews: PreviewProvider {
    static var previews: some View {
        ActiveFeedView()
    }
}
