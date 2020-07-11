//
//  DynamicListView.swift
//  bibs
//
//  Created by Paul Hendrick on 10/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct DynamicListView<T: NSManagedObject, Content: View>: View {
    @Environment(\.managedObjectContext) var moc
    
    var fetchRequest: FetchRequest<T>
    var results: FetchedResults<T> { fetchRequest.wrappedValue }
    
    var content: (T) -> Content
    
    init(filterKey: String, filterValue: Int16 = 0, @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(
            entity: T.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "%K IN %@", filterKey, [filterValue])
        )
        
        self.content = content
    }
    
    var body: some View {
        List {
            ForEach(fetchRequest.wrappedValue, id: \.self) {result in
                self.content(result)
            }
            .onDelete { (indexSet) in
                indexSet.forEach { (index) in
                    self.moc.delete(self.results[index])
                }
                
                try? self.moc.save()
            }
        }
    }
}

//struct DynamicListView_Previews: PreviewProvider {
//    static var previews: some View {
//        DynamicListView()
//    }
//}
