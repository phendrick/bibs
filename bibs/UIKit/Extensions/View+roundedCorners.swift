//
//  RoundedCorners.swift
//  designs
//
//  Created by Paul Hendrick on 17/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
import SwiftUI

/// A RoundedCorners shape that can be applied to a view
/// by calling .background(RoundedCorners(...))
struct RoundedCorners: Shape {
    var cornerRadius: CGFloat = .zero
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        
        return Path(path.cgPath)
    }
}

/// A RoundedTopBorder modifier that can be applied to a view
/// by calling .modifier(RoundedTopBorder(...)
struct RoundedTopBorder: ViewModifier {
    var offset: CGFloat = 0
    var backgroundColor: Color = .black
    var foregroundColor: Color = .white
    var corners: UIRectCorner = .allCorners
    
    func body(content: Content) -> some View {
        return content
            .padding(.top, offset)
            .background(
                ZStack {
                    RoundedCorners(cornerRadius: 20, corners: corners)
                        .foregroundColor(backgroundColor)
                    RoundedCorners(cornerRadius: 20, corners: corners)
                        .foregroundColor(foregroundColor)
                        .padding(.top, offset)
                }
            )
    }
}

/// Extend view with .roundedTopBorder() functions to modify the appearance of a view with a rounded border and cap
extension View {
    func roundedTopBorder(offset: CGFloat) -> ModifiedContent<Self, RoundedTopBorder> {
        return modifier(RoundedTopBorder(offset: offset))
    }
    
    func roundedTopBorder(offset: CGFloat, backgroundColor: Color, foregroundColor: Color) -> ModifiedContent<Self, RoundedTopBorder> {
        return modifier(RoundedTopBorder(offset: offset, backgroundColor: backgroundColor, foregroundColor: foregroundColor))
    }
}
