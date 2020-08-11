//
//  ExpressedMilkDataView.swift
//  bibs
//
//  Created by Paul Hendrick on 10/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI


struct ExpressedMilkDataView: View {
    @ObservedObject var profile: ProfileObserver
    
    @State var expressedBottleStorageType: ExpressedBottle.ExpressedBottleStorageStatus = .refridgerated

    @State var dateFilter: DataViewDateFilter = .today
    @State var dateFilterStartDate: Date = Date().beginningOfMonth
    @State var dateFilterEndDate: Date = Date().endOfMonth
    @State var dateOptionsSheetVisible: Bool = false
    
    func statsForResults(results: [Snack]) -> String {
        guard results.count > 0 else {
            return ""
        }
        
        return "\(results.count) \("snack".pluralize(count: results.count))"
    }
    
    @ViewBuilder func headerView(results: [ExpressedBottle]) -> some View {
        guard results.count > 0 else {
            return ""
        }
        
        return "\(results.count) \("bottle".pluralize(count: results.count))"
    }
    
    @ViewBuilder func headerView(results: [Snack]) -> some View {
        Section {
            Text("\(statsForResults(results: results))")
        }
    }
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Picker(selection: self.$expressedBottleStorageType, label: Text("")) {
                        ForEach(ExpressedBottle.ExpressedBottleStorageStatus.allCases, id: \.self) {storage in
                            Text("\(storage.description)").tag(storage.rawValue)
                        }
                    }
                }
                
                DashboardDataView(
                    profile: self.profile,
                    predicate: NSPredicate(format: "%K IN %@", "state", [self.expressedBottleStorageType.rawValue]),
                    sortDescriptors: [
                        NSSortDescriptor(key: "createdAt", ascending: false)
                    ],
                    headerView: headerView
                ) {(result: ExpressedBottle, count: Int) in
                    NavigationLink(destination: EditExpressedMilkView(profile: self.profile, expressedBottle: result)) {
                        HStack {
                            Text("\(result.convertedAmount) ")
                            Text("\(result.wrappedCreatedAt.getFormattedDate())")
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text("Expressed Milk"), displayMode: .large)
        .navigationBarItems(trailing: EditButton())
    }
}

//struct ExpressedMilkDataView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpressedMilkDataView()
//    }
//}
