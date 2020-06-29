//
//  DataviewView.swift
//  bibs
//
//  Created by Paul Hendrick on 27/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import Introspect

struct DataviewView: View {
    func updatePageIndex(index: Int) {
        print("Set page \(index)")
    }
    
    var body: some View {
        GeometryReader {outerGeometry in
            VStack {
                ScrollView {
                    HStack {
                        Text("OK")
                    }
                }
            }
        }
    }
}

struct DataviewView_Previews: PreviewProvider {
    static var previews: some View {
        DataviewView()
    }
}
