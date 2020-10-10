//
//  ParentTrackerFormSheet.swift
//  bibs
//
//  Created by Paul Hendrick on 07/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ParentTrackerFormSheet: View {
    @ObservedObject var profile: ProfileObserver
    @Environment(\.managedObjectContext) var moc
    @Binding var parentTrackerFormVisible: Bool
    
    @State var form = 0
    
    @State var foodDiaryNote: String = ""
    @State var selectedFoodType: FoodDiaryEntry.FoodType?
    
    @State var emotionNote: String = ""
    @State var selectedEmotionType: Emotion.EmotionType?
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("about_you".localized)
                Spacer()
                
                Button("\("save".localized) \(self.form == 0 ? "emotion".localized : "food_diary".localized)") {
                    if self.form == 0 {
                        guard let emotionType = self.selectedEmotionType else {
                            return
                        }
                        
                        let emotion = Emotion(context: self.moc)
                        emotion.createdAt = Date()
                        emotion.note = self.emotionNote
                        emotion.status = emotionType
                        
                        self.profile.parent.addToEmotions(emotion)
                    }else {
                        guard let foodType = self.selectedFoodType else {
                            return
                        }
                        
                        let foodDiaryEntry = FoodDiaryEntry(context: self.moc)
                        foodDiaryEntry.createdAt = Date()
                        foodDiaryEntry.note = self.foodDiaryNote
                        foodDiaryEntry.foodType = foodType
                        
                        self.profile.parent.addToFoodDiaryEntries(foodDiaryEntry)
                    }
                    
                    do {
                        try self.moc.save()
                        self.profile.objectWillChange.send()
                        
                        self.parentTrackerFormVisible = false
                    }catch {
                    }
                }
            }
            .animation(.linear)
            .font(.headline)
            .padding()
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .clipped()
            .shadow(color: .gray, radius: 1, x: 0, y: 0)
            
            Picker(selection: self.$form, label: Text("OK")) {
                Text("how_are_you".localized).tag(0)
                Text("your_food_diary".localized).tag(1)
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if self.form == 0 {
                EmotionDiaryFormSheet(emotionNote: self.$emotionNote, selectedEmotionType: $selectedEmotionType)
            }else {
                FoodDiaryFormSheet(foodDiaryNote: self.$foodDiaryNote, selectedFoodType: $selectedFoodType)
            }
        }
        .animation(.linear)
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor.systemGray6))
    }
}

struct ParentTrackerFormSheet_Previews: PreviewProvider {
    static var previews: some View {
        ParentTrackerFormSheet(profile: ProfileObserver.shared, parentTrackerFormVisible: .constant(true))
    }
}
