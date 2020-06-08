//
//  ActiveFeedsView.swift
//  bibs
//
//  Created by Paul Hendrick on 24/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ActiveFeedsView: View {
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        VStack {
            Text("OK")
        }
    }
    
    func addChild() {
    }
}

struct ActiveFeedsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return ActiveFeedsView()
            .environmentObject(ActiveFeedSessions.shared)
            .environment(\.managedObjectContext, context)
    }
}
