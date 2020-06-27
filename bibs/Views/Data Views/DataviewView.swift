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
    var scrollViewDelegate: CustomUIScrollViewDelegate!
    
    init() {
        self.scrollViewDelegate = CustomUIScrollViewDelegate(scrollViewDidEndDeceleratingCallback: updatePageIndex)
    }
    
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
                .introspectScrollView { (scrollView) in
                    self.scrollViewDelegate.pageWidth = outerGeometry.size.width
                    self.scrollViewDelegate.pageCount = FeedTool.allCases.count
                    
                    scrollView.isPagingEnabled = true
                    scrollView.delegate = self.scrollViewDelegate
                    self.scrollViewDelegate.scrollViewDidEndDeceleratingCallback = self.updatePageIndex
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
