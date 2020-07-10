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
                
                Image(systemName: "ear")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 180)
                    .padding(.top, 80)
                
                Text("Nappy Change")
                    .font(.system(size: 30))
                    .padding(.top, 20)
                    .padding(.bottom, 80)
                
                Picker(selection: self.$nappyType, label: Text("K")) {
                    ForEach(NappyChange.NappyChangeType.allCases, id: \.self) {type in
                        Text("\(type.description)").tag(type.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
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
