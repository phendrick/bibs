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
    
    let imageBaseHeight = UIScreen.main.bounds.size.height / 12
    
    var imageSize: CGFloat {
        if self.layout == .expanded {
            return imageBaseHeight * 1.5
        }else {
            return imageBaseHeight
        }
    }
    
    var avatarHeight: CGFloat {
        switch(self.layout) {
        case .expanded: return UIScreen.main.bounds.height/8
        case .minimised: return UIScreen.main.bounds.height/12
        }
    }
    
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
        return AvatarImageView(image: image, color: .red)
            .previewLayout(.fixed(width: 400, height: 300))
        
    }
}
