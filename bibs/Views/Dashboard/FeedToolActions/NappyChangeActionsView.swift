//
//  NappyChangeActionsView.swift
//  bibs
//
//  Created by Paul Hendrick on 06/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct NappyChangeActionsView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    @FetchRequest(
        entity: NappyChange.entity(),
        sortDescriptors: []) var nappyChanges: FetchedResults<NappyChange>
        
    @State var nappyChangeFormVisible: Bool = false
    @State var nappyType: Int = 0
    @State var nappyChangeAmountType: Int = 0
    @State var nappyChangePoopColor: NappyChange.NappyChangePoopColor = .brown
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.nappyChangeFormVisible.toggle()
                }) {
                    HStack {
                        Text("Nappy Change")
                        Spacer()
                    }.padding()
                }
                
                NavigationLink(destination: NappyChangeDataView().environment(\.managedObjectContext, self.moc)) {
                    Text("Manage Nappy Changes")
                }
            }
            .background(Color.yellow)
            
            Divider()
            
            ForEach(self.profile.parent.activeChild?.nappyChangesArray ?? [], id: \.self) {nappy in
                Text("Nappy \(nappy.state)")
            }
        }
        .sheet(isPresented: self.$nappyChangeFormVisible) {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.nappyChangeFormVisible = false
                    }) {
                        Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                    }.padding([.top, .trailing], 15)
                }
                
                Text("Nappy Change")
                    .font(.system(size: 30))
                    .padding(.top, 20)
                    .padding(.bottom, 80)
                
                Form {
                    Section(
                        header: Text("Nappy change type")
                    ) {
                        Picker(selection: self.$nappyType, label: Text("K")) {
                            ForEach(NappyChange.NappyChangeType.allCases, id: \.self) {type in
                                Text("\(type.description)").tag(type.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        VStack(alignment: .leading) {
                            Text("What was the colour?").font(.subheadline)
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
                                Spacer()
                            }.padding()

                            VStack(alignment: .leading) {
                                Text("\(self.nappyChangePoopColor.details.0)")
                                    .font(.headline)
                                Text("\(self.nappyChangePoopColor.details.1)")
                                    .font(.subheadline)
                            }
                            .animation(nil)
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
                    Button(action: {
                        let nappyChange = NappyChange(context: self.moc)
                        nappyChange.state = Int16(self.nappyType)
                        nappyChange.createdAt = Date()
                        self.profile.parent.activeChild?.addToNappyChanges(nappyChange)
                        
                        do {
                            try self.moc.save()
                        }catch {
                        }
                        
                        self.nappyChangeFormVisible = false
                    }) {
                        Text("Done")
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
}

struct NappyChangeActionsView_Previews: PreviewProvider {
    static var previews: some View {
        NappyChangeActionsView()
    }
}
