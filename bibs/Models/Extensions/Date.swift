
//
//  SwiftUIView.swift
//  bibs
//
//  Created by Paul Hendrick on 04/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//
import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        
        return dateformat.string(from: self)
    }
}
