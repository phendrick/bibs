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
            .frame(minWidth: 50, minHeight: 50)
            .animation(.linear)
    }
}

struct AvatarImageView_Previews: PreviewProvider {
    static var previews: some View {
        let image = Image("baby")
        return AvatarImageView(image: image, color: .red)
            .previewLayout(.fixed(width: 400, height: 300))
        
    }
}
