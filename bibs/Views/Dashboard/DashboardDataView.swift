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
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .opacity(offset == 0 ? 1 : 0)
                .offset(x: 0, y: self.offset)
            
            if( fetchRequest.wrappedValue.count > 0 ) {
                List {
                    ForEach(fetchRequest.wrappedValue.indices, id: \.self) { index in
                        DashboardDataRowView(index: index) {
                            self.content(self.fetchRequest.wrappedValue[index], index)
                        }
                        .listRowInsets(EdgeInsets())
                    }
                    .onDelete(perform: removeRows)
                }
            }else {
                List {
                    DashboardDataRowView(index: 1) {
                        Text("Hello")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .listRowInsets(EdgeInsets())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            UITableView.appearance().separatorColor = .clear
            
            withAnimation {
                self.offset = 0
            }
        }
        .onDisappear(perform: {
            withAnimation {
                self.offset = 100
            }
        })
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
