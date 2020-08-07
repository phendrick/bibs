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
            Picker(selection: self.$form, label: Text("OK")) {
                Text("How are you?").tag(0)
                Text("Your food diary").tag(1)
            }
            .labelsHidden()
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if self.form == 0 {
                EmotionDiaryFormSheet(emotionNote: self.$emotionNote, selectedEmotionType: $selectedEmotionType)
            }else {
                FoodDiaryFormSheet(foodDiaryNote: self.$foodDiaryNote, selectedFoodType: $selectedFoodType)
            }
            
            Spacer()
            
            VStack {
                Button("Save") {
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
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height/8)
            .background(Color(UIColor.systemBackground))
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color(UIColor.systemGray6))
    }
}

struct ParentTrackerFormSheet_Previews: PreviewProvider {
    static var previews: some View {
        ParentTrackerFormSheet(profile: ProfileObserver.shared, parentTrackerFormVisible: .constant(true))
    }
}
