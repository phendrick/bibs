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
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                if report != nil {
                    HStack {
                        Text(emotion.status.emoji).font(.title)
                        Text(emotion.wrappedCreatedAt.getFormattedDate())
                    }
                    
                    ForEach(Array(report!.keys), id: \.self) {key in
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(spacing: 10) {

                                HStack {
                                    HStack {
                                        Text("\(key)".localized).font(.headline).foregroundColor(.orange)
                                        Spacer()
                                    }
                                }
                            }

                            ForEach(Array(report![key]!), id: \.self) {value in
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(value.localized).font(.headline)
                                    Text("\(value)_details".localized).font(.subheadline)
                                        .onTapGesture {
                                            print(value)
                                        }
                                }.fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(10).padding([.leading, .trailing], 5)
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))
                    }
                }else {
                    VStack(spacing: 10) {
                        Text("sorry".localized).font(.headline)
                        Text("no_insights_found".localized).font(.subheadline)
                    }
                }
                
                Spacer()
                
                if report != nil {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("remember".localized).font(.headline)
                            Image(systemName: "lightbulb")
                        }
                        
                        Text("insights_disclaimer".localized).font(.caption)
                        
                        HStack {
                            Text(String(format: "insights_disclaimer_footer".localized, "doctor")) + Text(".")
                        }.font(.caption)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .navigationBarTitle("insights".localized)
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
        }.frame(maxWidth: .infinity)
    }
}

struct ParentEmotionListView: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var profile: ProfileObserver
    
    func removeRows(at offsets: IndexSet) {
        for index in offsets {
            let row = self.profile.parent.emotionsArray[index]
            self.context.delete(row)
        }
        
        //self.moc.refreshAllObjects()
        try? self.context.save()
        self.profile.objectWillChange.send()
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(self.profile.parent.emotionsArray, id: \.self) {emotion in
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
                .onDelete(perform: removeRows)
            }
        }
        .navigationBarTitle(Text("emotions".localized))
    }
}

struct ParentEmotionListView_Previews: PreviewProvider {
    static var previews: some View {
        ParentEmotionListView(profile: ProfileObserver.shared)
    }
}
