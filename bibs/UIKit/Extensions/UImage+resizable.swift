//
//  UImage+resizable.swift
//  bibs
//
//  Created by Paul Hendrick on 05/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resize(newSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio = newSize.width / size.width
        let heightRatio = newSize.height / size.height
        
        var updatedSize: CGSize
        
        if widthRatio > heightRatio {
            updatedSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        }else {
            updatedSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: updatedSize.width, height: updatedSize.height)
        UIGraphicsBeginImageContextWithOptions(updatedSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
