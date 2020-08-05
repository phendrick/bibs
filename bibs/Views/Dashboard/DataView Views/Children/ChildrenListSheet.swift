//
//  ChildrenListSheet.swift
//  bibs
//
//  Created by Paul Hendrick on 27/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChildrenListSheet: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    @Binding var childrenSheetVisible: Bool
    
    var body: some View {
        VStack {
            ForEach(self.profile.parent.childrenArray, id: \.self) {child in
                VStack(spacing: 40) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("\(child.wrappedName)").font(.largeTitle)
                            
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Feeds").font(.headline)
                                    Text("354")
                                }
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Naps").font(.headline)
                                    Text("84")
                                }
                                
                                VStack(alignment: .leading, spacing: 15) {
                                    Text("Nappy Changes").font(.headline)
                                    Text("254")
                                }
                            }
                            .padding([.top, .bottom], 5)
                            .foregroundColor(.black)
                            .opacity(0.5)
                        }
                        .padding([.leading, .trailing])
                        .padding([.top, .bottom])
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(child.theme.0)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    if self.profile.parent.activeChild != child {
                        Button("Set as default") {
                            self.profile.parent.activeChild = child
                            
                            do {
                                try self.moc.save()
                            }catch {
                                debugPrint("Error setting child as default")
                            }
                        }
                    }
                }
            }
            
            Spacer()
            
        }.padding()
    }
}

struct ChildrenListSheet_Previews: PreviewProvider {
    static var previews: some View {
        ChildrenListSheet(childrenSheetVisible: .constant(true))
    }
}
