//
//  ParentEmotionListView.swift
//  bibs
//
//  Created by Paul Hendrick on 08/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ParentEmotionListView: View {
    @ObservedObject var profile: ProfileObserver
    
    var centerPoint:CGFloat = UIScreen.main.bounds.size.height
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    Text("")
                }
                .frame(maxHeight: .infinity)
                .frame(width: 0)
                .border(Color.gray.opacity(0.35))
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(self.profile.parent.emotionsArray.reversed(), id: \.self) {emotion in
                        VStack {
                            Text("\(emotion.status.description)").font(.headline).padding(.bottom, 5)
                            Text("\(emotion.status.emoji)").font(.system(size: 80))
                            
                            VStack(spacing: 5) {
                                Text("\(emotion.note ?? "")")
                                    .font(.caption).foregroundColor(Color(UIColor.label).opacity(0.75))
                                
                                Text("\(emotion.wrappedCreatedAt.getFormattedDate())")
                                    .font(.caption).foregroundColor(Color(UIColor.label).opacity(0.75))
                            }
                        }
                        .padding(.bottom, 45)
                    }
                }
            }
        }.navigationBarTitle(Text("Emotions"), displayMode: .inline)
    }
}

struct ParentEmotionListView_Previews: PreviewProvider {
    static var previews: some View {
        ParentEmotionListView(profile: ProfileObserver.shared)
    }
}
