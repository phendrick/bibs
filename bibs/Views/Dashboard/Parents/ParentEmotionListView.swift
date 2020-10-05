//
//  ParentEmotionListView.swift
//  bibs
//
//  Created by Paul Hendrick on 08/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

struct ParentEmotionInsightsView: View {
    @Environment(\.managedObjectContext) var moc
    @State var generatingReport: Bool = false
    @State var report: InsightReport?
    
    var emotion: Emotion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(emotion.status.emoji).font(.title)
                Text(emotion.wrappedCreatedAt.getFormattedDate())
            }
            if report != nil {
                ForEach(Array(report!.keys), id: \.self) {key in
                    VStack(alignment: .leading, spacing: 10) {
                        VStack(spacing: 10) {

                            HStack {
                                HStack {
                                    Text("\(key)".localized).font(.headline).foregroundColor(.orange)
                                    Spacer()
                                }
                                
//                                Text("Something")
//                                    .font(.caption)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(Color(UIColor.tertiaryLabel))
                            }
                        }

                        ForEach(Array(report![key]!), id: \.self) {value in
                            VStack(alignment: .leading, spacing: 10) {
                                Text("\(value)".localized).font(.headline)
                                Text("\(value)_details".localized).font(.subheadline)
                            }
                        }
                    }
                    .padding(5).padding([.leading, .trailing], 5)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                }
            }else {
                HStack {
                    Text("Sorry!").font(.title)
                    Text("No insights available").font(.caption)
                }
            }
            
            Spacer()
            
            if report != nil {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Remember").font(.headline)
                        Image(systemName: "lightbulb")
                    }
                    
                    Text("The insights that we generate can only be used as a reference for the data surrounding the time when you recorded this emotion. They shouldn't be depended on in place of medical advice. ").font(.caption)
                    
                    HStack {
                        Text("If you have any concerns about you or your baby, please consult your ") + Text("doctor".localized) + Text(".")
                    }.font(.caption)
                }
            }
        }
        .padding()
        .navigationBarTitle("Insights".localized)
        .onAppear {
            let reportGenerator = EmotionInsightsGenerator(emotion: emotion, context: self.moc)
            self.generatingReport = true
            
            Dispatch.background {
                let report = reportGenerator.generate()
                
                Dispatch.main {
                    self.generatingReport = false
                    self.report = report
                }
            }
        }
    }
}

struct ParentEmotionListView: View {
    @ObservedObject var profile: ProfileObserver
    
    var centerPoint:CGFloat = UIScreen.main.bounds.size.height
    
    var body: some View {
        VStack {
            List(self.profile.parent.emotionsArray, id: \.self) {emotion in
                NavigationLink(destination: ParentEmotionInsightsView(emotion: emotion)) {
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
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 45)
                }
            }
        }
        .navigationBarTitle(Text("Emotions"))
    }
}

struct ParentEmotionListView_Previews: PreviewProvider {
    static var previews: some View {
        ParentEmotionListView(profile: ProfileObserver.shared)
    }
}
