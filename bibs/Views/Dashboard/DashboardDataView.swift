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
    var title: String?
    
    var fetchRequest: FetchRequest<T>
    var results: FetchedResults<T> { fetchRequest.wrappedValue }
    
    var content: (T, Int) -> Content
    
    @State var offset: CGFloat = -5
    
    init(title: String = "", predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = [], @ViewBuilder content: @escaping(T, Int) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: sortDescriptors, predicate: predicate, animation: .spring())
        self.content = content
        self.title = title
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title ?? "")
                .font(.system(size: 32, weight: .medium, design: .rounded))
                .opacity(offset == 0 ? 1 : 0)
                .offset(x: 0, y: self.offset)
            
            List {
                ForEach(fetchRequest.wrappedValue.indices, id: \.self) { index in
                    DashboardDataRowView(index: index) {
                        self.content(self.fetchRequest.wrappedValue[index], index)
                    }
                }
            }
        }.onAppear {
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
