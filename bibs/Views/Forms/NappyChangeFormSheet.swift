//
//  NappyChangeFormSheet.swift
//  bibs
//
//  Created by Paul Hendrick on 26/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct NappyChangeFormSheet: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    @Binding var nappyChangeFormVisible: Bool
    @State var nappyType: Int = 0
    @State var nappyChangeAmountType: Int = 0
    @State var nappyChangePoopColor: NappyChange.NappyChangePoopColor = .brown
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("nappy_change".localized)
                Spacer()
                
                Button("save".localized) {
                    guard let child = self.profile.parent.activeChild else {
                        debugPrint("No activeChild")
                        return
                    }
                    
                    let nappyChange = NappyChange(context: self.moc)
                    nappyChange.state = Int16(self.nappyType)
                    nappyChange.amount = Int16(self.nappyChangeAmountType)
                    nappyChange.poopColor = self.nappyChangePoopColor
                    nappyChange.createdAt = Date()
                    child.addToNappyChanges(nappyChange)

                    do {
                        try self.moc.save()
                        self.profile.objectWillChange.send()
                        self.nappyChangeFormVisible = false
                    }catch {
                    }
                }
            }
            .font(.headline)
            .padding()
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .clipped()
            .shadow(color: .gray, radius: 1, x: 0, y: 0)
            
            if profile.parent.activeChildrenArray.count > 1 {
                ChildrenFormList()
                    .padding()
                    .animation(nil)
            }
            
            Form {
                Section(
                ) {
                    Picker(selection: self.$nappyType, label: Text("Select a nappy type")) {
                        ForEach(NappyChange.NappyChangeType.allCases, id: \.self) {type in
                            Text("\(type.description)").tag(type.rawValue)
                        }
                    }
                    .font(.caption)
                    .pickerStyle(SegmentedPickerStyle())

                    VStack(alignment: .leading) {
                        HStack(alignment: .lastTextBaseline) {
                            Text("\(self.nappyChangePoopColor.details.0)")
                                .font(Font.caption.weight(.bold))
                            Text("\(self.nappyChangePoopColor.details.1)")
                                .font(.caption)
                        }
                        .animation(nil)
                        
                        HStack(alignment: .center) {
                            ForEach(NappyChange.NappyChangePoopColor.allCases, id: \.self) {poopColor in
                                VStack {
                                    EmptyView()
                                }
                                .frame(width: 30, height: 30)
                                .background(Color(poopColor.color))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            self.nappyChangePoopColor == poopColor ? Color(poopColor.color) : Color.clear,
                                            lineWidth: 8
                                        )
                                )
                                .padding(5)
                                .onTapGesture {
                                    self.nappyChangePoopColor = poopColor
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 15)
                    .opacity(
                        [NappyChange.NappyChangeType.dirty.rawValue, NappyChange.NappyChangeType.both.rawValue].contains(self.nappyType)
                            ? 1
                            : 0.25
                    )
                    .disabled(![NappyChange.NappyChangeType.dirty.rawValue, NappyChange.NappyChangeType.both.rawValue].contains(self.nappyType))
                }.animation(.spring())
                
                Section(
                    header: Text("amount".localized)
                ) {
                    Picker(selection: self.$nappyChangeAmountType, label: Text("")) {
                        ForEach(NappyChange.NappyChangeAmountType.allCases, id: \.self) {nappy in
                            Text("\(nappy.description)").tag(nappy.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                }.animation(.spring())
            }.layoutPriority(100)
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor.systemGray6))
        .font(.headline)
    }
}

struct NappyChangeFormSheet_Previews: PreviewProvider {
    static var previews: some View {
        NappyChangeFormSheet(nappyChangeFormVisible: .constant(true))
    }
}
