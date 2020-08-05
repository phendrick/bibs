//
//  Call a content block for each Core Data result for a given entity and predicate
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
    @Environment(\.managedObjectContext) var moc
    
    var title: String?
    var allowDelete: Bool = true
    var fetchRequest: FetchRequest<T>
    var results: FetchedResults<T> { fetchRequest.wrappedValue }
    
    var content: (T, Int) -> Content
    
    init(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = [],
        allowDelete: Bool = true,
        @ViewBuilder content: @escaping(T, Int) -> Content
    ) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: predicate, animation: .spring())
        self.content = content
        self.allowDelete = allowDelete
    }
    
    func removeRows(at offsets: IndexSet) {
        for index in offsets {
            let row = results[index]
            self.moc.delete(row)
        }
        
        self.moc.refreshAllObjects()
        try? self.moc.save()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(fetchRequest.wrappedValue.indices, id: \.self) { index in
                    DashboardDataRowView(index: index) {
                        self.content(self.fetchRequest.wrappedValue[index], index)
                    }
                }
                .onDelete(perform: removeRows)
            }
        }
    }
}

//struct DashboardDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        return DashboardDataView(title: "OK") { (result: Child, index) in
//            Text("OK")
//        }
//        .environment(\.managedObjectContext, context)
//    }
//}
