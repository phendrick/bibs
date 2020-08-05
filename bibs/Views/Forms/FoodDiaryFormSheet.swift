//
//  FoodDiaryFormSheet.swift
//  bibs
//
//  Created by Paul Hendrick on 31/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FoodDiaryFormSheet: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    @Binding var foodDiaryFormVisible: Bool
    
    @State var note: String = ""
    @State var selectedSnackType: Snack.SnackType = .vegetables
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    self.foodDiaryFormVisible = false
                }) {
                    Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                }.padding([.top, .trailing], 15)
            }
            
            Text("You").font(.title)
            
            if self.profile.parent.showFoodDiaryPrompt == true {
                VStack {
                    ZStack(alignment: .topLeading) {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    self.profile.parent.showFoodDiaryPrompt = false
                                    self.profile.parent.objectWillChange.send()
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill").foregroundColor(.red)
                            }.padding([.top, .trailing], 15)
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Look after yourself too!")
                                .padding([.leading, .top, .trailing])
                                .font(.headline)
                            Text("Something here about healthy eating and calorie counts keeping to keep your milk supply up, and ensuring that it's nutricious.")
                                .font(.caption).padding().padding(.trailing, 50)
                            
                            Text("Maybe include some links to online resources here. Or  just some suggestions for ideal foods.")
                            .font(.caption).padding().padding(.trailing, 50)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(15)
                .padding()
            }
            
            Form {
                Section(
                    header: Text("Add a note eg. \"Carrot sticks\"").onTapGesture {self.profile.parent.showFoodDiaryPrompt = true}
                ) {
                    TextField(self.note, text: self.$note)
                }
                
                Section(
                    header: Text("Snack type")
                ) {
                    List {
                        ForEach(Snack.SnackType.allCases, id: \.self) {snack in
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    Text("\(snack.description)").font(.headline).padding(.bottom, 10)
                                    Text("\(snack.details)").font(.subheadline)
                                }
                                Spacer()
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(UIColor.systemGreen) )
                                    .opacity(self.selectedSnackType == snack ? 1 : 0.2)
                            }
                            .padding(5).tag(snack)
                            .onTapGesture {
                                withAnimation {
                                    self.selectedSnackType = snack
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor.systemGray6))
    }
}


struct FoodDiaryFormSheet_Previews: PreviewProvider {
    static var previews: some View {
        FoodDiaryFormSheet(foodDiaryFormVisible: .constant(true))
    }
}

