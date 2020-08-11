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

struct DashboardDataView<T: NSManagedObject, Header: View, Content: View>: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var profile: ProfileObserver
    
    var title: String?
    var allowDelete: Bool = true
    var fetchRequest: FetchRequest<T>
    var results: FetchedResults<T> { fetchRequest.wrappedValue }
    var dateFilter: DataViewDateFilter = .today
    
    var headerView: ([T]) -> Header
    var content: (T, Int) -> Content
    
    init(
        profile: ProfileObserver,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor] = [],
        allowDelete: Bool = true,
        @ViewBuilder headerView: @escaping([T]) -> Header,
        @ViewBuilder content: @escaping(T, Int) -> Content
    ) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: predicate, animation: .spring())
        self.profile = profile
        self.headerView = headerView
        self.content = content
        self.allowDelete = allowDelete
    }
    
    func removeRows(at offsets: IndexSet) {
        for index in offsets {
            let row = results[index]
            self.moc.delete(row)
        }
        
        //self.moc.refreshAllObjects()
        try? self.moc.save()
        self.profile.objectWillChange.send()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            self.headerView(Array(fetchRequest.wrappedValue)).padding().font(.caption)
            
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

