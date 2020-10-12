//
//  AvatarImageView.swift
//  bibs
//
//  Created by Paul Hendrick on 05/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct AvatarImageView: View {
    var image: Image!
    var color: Color
    var lineWidth: CGFloat = 10
    var layout: ActiveFeedsTrayView.ExpandedState = .minimised
    
    var body: some View {
        image
            .resizable()
            .clipShape(Circle())
            .shadow(radius: 5)
            .scaledToFit()
            .clipped()
            .overlay(
                Circle().stroke(
                    color, lineWidth: lineWidth
                )
            )
    }
}

struct AvatarImageView_Previews: PreviewProvider {
    static var previews: some View {
        let image = Image("baby")
        return AvatarImageView(image: image, color: Color(UIColor(named: "HighlightRed") ?? UIColor.red))
            .previewLayout(.fixed(width: 400, height: 300))
        
    }
}
