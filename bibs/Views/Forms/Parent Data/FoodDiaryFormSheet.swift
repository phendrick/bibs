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
            Form {
                Section(
                    header: Text("ive_had".localized)
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
                            .animation(nil)
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
