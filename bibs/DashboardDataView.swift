//
//  DashboardDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct DashboardDataView<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var results: FetchedResults<T> { fetchRequest.wrappedValue }
    
    var content: (T, Int) -> Content
    
    init(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = [], @ViewBuilder content: @escaping(T, Int) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: predicate, animation: .spring())
        self.content = content
    }
    
    var body: some View {
        ForEach(fetchRequest.wrappedValue.indices, id: \.self) { index in
            DashboardDataRowView(index: index) {
                self.content(self.fetchRequest.wrappedValue[index], index)
            }
        }
    }
}

struct DashboardDataView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardDataView() { (result: Child, index) in
            Text("OK")
        }
    }
}
