//
//  FoodDiaryFormSheet.swift
//  bibs
//
//  Created by Paul Hendrick on 31/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct FoodDiaryFormSheet: View {
    @Binding var foodDiaryNote: String
    @Binding var selectedFoodType: FoodDiaryEntry.FoodType?
    
    var body: some View {
        VStack {
//            VStack {
//                ZStack(alignment: .topLeading) {
//                    VStack(alignment: .leading, spacing: 0) {
//                        Text("Look after yourself too!")
//                            .padding([.leading, .top, .trailing])
//                            .font(.headline)
//                        Text("Something here about healthy eating and calorie counts keeping to keep your milk supply up, and ensuring that it's nutricious.")
//                            .font(.caption).padding().padding(.trailing, 50)
//
//                        Text("Maybe include some links to online resources here. Or  just some suggestions for ideal foods.")
//                        .font(.caption).padding().padding(.trailing, 50)
//                    }
//                }
//            }
//            .frame(maxWidth: .infinity)
//            .background(Color(UIColor.secondarySystemGroupedBackground))
//            .cornerRadius(15)
//            .padding()
//
            Form {
                Section(
                    header: Text("I've had")
                ) {
                    List {
                        ForEach(FoodDiaryEntry.FoodType.allCases, id: \.self) {snack in
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    Text("\(snack.description)").font(.headline).padding(.bottom, 10)
                                    Text("\(snack.details)").font(.subheadline)
                                }
                                Spacer()
                                
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(UIColor.systemGreen) )
                                    .opacity(self.selectedFoodType == snack ? 1 : 0.2)
                            }
                            .padding(5).tag(snack)
                            .onTapGesture {
                                self.selectedFoodType = snack
                            }
                        }
                    }
                }
                
                Section(
                    header: Text("weaning_note_hint".localized)
                ) {
                    TextField(self.foodDiaryNote, text: self.$foodDiaryNote)
                }
            }
        }
    }
}

//
//struct FoodDiaryFormSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodDiaryFormSheet(foodDiaryFormVisible: .constant(true))
//    }
//}
//
