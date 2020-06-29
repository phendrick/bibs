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
    
    @State var offset: CGFloat = -5
    
    init(
        title: String = "",
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = [],
        allowDelete: Bool = true,
        @ViewBuilder content: @escaping(T, Int) -> Content
    ) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: predicate, animation: .spring())
        self.content = content
        self.title = title
        self.allowDelete = allowDelete
    }
    
    func removeRows(at offsets: IndexSet) {
        for index in offsets {
            let row = results[index]
            self.moc.delete(row)
        }
        
        try? self.moc.save()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title ?? "")
                .font(.custom("Merriweather-Regular", size: 26))
                .opacity(offset == 0 ? 1 : 0)
                .offset(x: 0, y: self.offset)
                .overlay(Text("Results \(fetchRequest.wrappedValue.count)").offset(y: 50))
            
            if( fetchRequest.wrappedValue.count > 0 ) {
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
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct DashboardDataView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return DashboardDataView(title: "OK") { (result: Child, index) in
            Text("OK")
        }
        .environment(\.managedObjectContext, context)
    }
}
