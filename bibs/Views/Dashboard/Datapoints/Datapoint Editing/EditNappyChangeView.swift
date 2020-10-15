//
//  EditNappyChangeView.swift
//  bibs
//
//  Created by Paul Hendrick on 09/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct EditNappyChangeView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var profile: ProfileObserver
    @ObservedObject var nappyChange: NappyChange
    
    @State var nappyType: Int = 0
    @State var nappyChangeAmountType: Int = 0
    @State var nappyChangePoopColor: NappyChange.NappyChangePoopColor = .brown
    
    var body: some View {
        VStack {
            Form {
                Section(
                    header: Text(String(format: "childs_nappy_was", self.profile.parent.activeChild?.wrappedName ?? "Baby"))
                ) {
                    Picker(selection: self.$nappyType, label: Text("Choose a nappy change type")) {
                        ForEach(NappyChange.NappyChangeType.allCases, id: \.self) {type in
                            Text("\(type.description)").tag(type.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    VStack(alignment: .leading) {
                        HStack(alignment: .lastTextBaseline) {
                            Text("\(self.nappyChangePoopColor.details.0)")
                                .font(Font.subheadline.weight(.bold))
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
            }
        }
        .onAppear(perform: {
            self.nappyType = Int(self.nappyChange.state)
            self.nappyChangeAmountType = Int(self.nappyChange.amount)
            self.nappyChangePoopColor = self.nappyChange.poopColor
        })
        .navigationBarItems(trailing: Button("save".localized) {
            self.nappyChange.state = Int16(self.nappyType)
            self.nappyChange.amount = Int16(self.nappyChangeAmountType)
            self.nappyChange.poopColor = self.nappyChangePoopColor
            
            do {
                try self.context.save()
                self.profile.objectWillChange.send()
                self.presentationMode.wrappedValue.dismiss()
            }catch {
            }
        })
    }
}

struct EditNappyChangeView_Previews: PreviewProvider {
    static var previews: some View {
        let nappy = NappyChange()
        return EditNappyChangeView(profile: ProfileObserver.shared, nappyChange: nappy)
    }
}
