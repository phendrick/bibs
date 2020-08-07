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
    
    var imageSize: CGFloat {
        if self.layout == .expanded {
            return 100
        }else if self.layout == .minimal {
            return 80
        }else {
            return 60
        }
    }
    
    var body: some View {
        image
            .resizable()
            .clipShape(Circle())
            .shadow(radius: 5)
            .scaledToFit()
            .overlay(
                Circle().stroke(
                    color, lineWidth: lineWidth
                )
            )
            .frame(minWidth: imageSize, minHeight: imageSize)
            .frame(maxHeight: imageSize)
            .animation(nil)
    }
}

struct AvatarImageView_Previews: PreviewProvider {
    static var previews: some View {
        let image = Image("baby")
        return AvatarImageView(image: image, color: .red)
            .previewLayout(.fixed(width: 400, height: 300))
        
    }
}
