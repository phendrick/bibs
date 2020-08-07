//
//  EmotionDiaryFormSheet.swift
//  bibs
//
//  Created by Paul Hendrick on 31/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct EmotionDiaryFormSheet: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var profile: ProfileObserver
    
    @Binding var emotionNote: String
    @Binding var selectedEmotionType: Emotion.EmotionType?
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Emotion.EmotionType.allCases, id: \.self) {emotion in
                        VStack {
                            Text("\(emotion.description)").font(.caption)
                            Text("\(emotion.emoji)")
                                .font(.system(size: 60))
                        }
                        .opacity(self.selectedEmotionType == emotion ? 1 : 0.5)
                        .onTapGesture {
                            withAnimation {
                                self.selectedEmotionType = emotion
                            }
                        }
                    }
                }
                .animation(.spring())
                .padding()
            }
            
            Form {
                Section(
                    header: Text("Add a little note about how you're feeling")
                ) {
                    TextField(self.emotionNote, text: self.$emotionNote)
                }
            }
            
            if self.selectedEmotionType == .down || self.selectedEmotionType == .sad {
                Text("Remember, if you're down it's totally normal. Maybe reach out to someone or join some online communities to share your thoughts ❤️ ").font(.caption).padding()
            }
        }
    }
}

//struct EmotionDiaryFormSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        EmotionDiaryFormSheet(emotionDiaryFormVisible: .constant(true), emotionNote: .constant(""), )
//    }
//}

struct TextView: UIViewRepresentable {
    
    typealias UIViewType = UITextView
    var configuration = { (view: UIViewType) in }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIViewType {
        UIViewType()
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<Self>) {
        configuration(uiView)
    }
}

