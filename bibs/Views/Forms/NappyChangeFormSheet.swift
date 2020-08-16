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
                Button(action: {
                    self.nappyChangeFormVisible = false
                }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                }.padding([.top, .trailing], 15)
            }
            
            Text("Nappy Change").font(.headline)
            
            if profile.parent.activeChildrenArray.count > 1 {
                ChildrenFormList()
                    .padding()
                    .animation(nil)
            }
            
            Form {
                Section(
                    header: Text("\(self.profile.parent.activeChild?.wrappedName ?? "Baby")'s nappy was")
                ) {
                    Picker(selection: self.$nappyType, label: Text("K")) {
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
                            Spacer()
                            ForEach(NappyChange.NappyChangePoopColor.allCases, id: \.self) {poopColor in
                                VStack {
                                    EmptyView()
                                }
                                .frame(width: 40, height: 40)
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
                            
                        }.padding()
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
                    header: Text("Amount")
                ) {
                    Picker(selection: self.$nappyChangeAmountType, label: Text("")) {
                        ForEach(NappyChange.NappyChangeAmountType.allCases, id: \.self) {nappy in
                            Text("\(nappy.description)").tag(nappy.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                }.animation(.spring())
            }
            
            Spacer()
            
            VStack {
                Button("Save") {
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
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height/8)
            .background(Color(UIColor.systemBackground))
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor.systemGray6))
    }
}

struct NappyChangeFormSheet_Previews: PreviewProvider {
    static var previews: some View {
        NappyChangeFormSheet(nappyChangeFormVisible: .constant(true))
    }
}
