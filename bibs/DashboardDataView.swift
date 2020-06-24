//
//  DashboardDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 23/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct DashboardDataView<T: NSManagedObject>: View {
    var fetchRequest: FetchRequest<T>
    var results: FetchedResults<T> { fetchRequest.wrappedValue }
    
    init(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = []) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: predicate, animation: .spring())
    }
    
    var body: some View {
        ForEach(fetchRequest.wrappedValue.indices, id: \.self) { index in
            DataRowView(index: index)
        }
    }
}

struct DashboardDataView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardDataView<Child>()
    }
}
