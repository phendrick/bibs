//
//  ChartContainer.swift
//  bibs
//
//  Created by Paul Hendrick on 30/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChartContainer: View {
    var introLabel: String {
        let ls = NSLocalizedString("feed count", comment: "")
        return String.localizedStringWithFormat(ls, "Paul", 2)
    }
    
    var timeLabel: String {
        let ls = NSLocalizedString("%ld hours %ld minutes %ld secs", comment: "")
        return String.localizedStringWithFormat(ls, 0, 20, 30)
    }
    
    /*
     You've fed $BABY 11 times so far today.
     That's 3 times more than at this time yesterday.
     
     In total today, $BABY has fed for 3 hours 7 minutes and
     14 seconds, with an average feed time of around 25 minutes.
    */
    
    var body: some View {
        VStack {
            Text(self.introLabel)
            Text(self.timeLabel).background(Color.red)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ChartContainer_Previews: PreviewProvider {
    static var previews: some View {
        ChartContainer().previewLayout(.fixed(width: 250, height: 200))
    }
}
