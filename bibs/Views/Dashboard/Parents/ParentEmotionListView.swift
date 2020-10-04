//
//  ParentEmotionListView.swift
//  bibs
//
//  Created by Paul Hendrick on 08/08/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CoreData

typealias InsightReport = [String: [String]]
struct EmotionInsightsGenerator {
    var emotion: Emotion
    var context: NSManagedObjectContext
    
    func generate() -> [String: [String]]? {
        let twoDays: Double = 3600*24*2
        
        let fromDate = emotion.wrappedCreatedAt.beginningOfDay.advanced(by: -twoDays)
        let dateFromPredicate = NSPredicate(format: "createdAt >= %@", fromDate as NSDate)
        let dateToPredicate   = NSPredicate(format: "createdAt < %@",  emotion.wrappedCreatedAt as NSDate)
        
        let predicates = [dateFromPredicate, dateToPredicate]
        
        let datePredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: predicates
        )
        
        let napsFetchRequest: NSFetchRequest<Nap> = Nap.fetchRequest()
        let feedsFetchRequest: NSFetchRequest<FeedSession> = FeedSession.fetchRequest()
        let bottlesFetchRequest: NSFetchRequest<BottleFeed> = BottleFeed.fetchRequest()
        
        napsFetchRequest.predicate = datePredicate
        feedsFetchRequest.predicate = datePredicate
        bottlesFetchRequest.predicate = datePredicate
        
        var results: [String: [String]] = [:]
        
        let naps    = try? self.context.fetch(napsFetchRequest)
        let feeds   = try? self.context.fetch(feedsFetchRequest)
        let bottles = try? self.context.fetch(bottlesFetchRequest)
        
        print("\n\n\n")
        print(naps?.count, feeds?.count, bottles?.count)
        print("\n\n\n")
        
        if emotion.status.rawValue < 4 {
            if let report = negativeInsightsForNaps(naps: naps ?? []) {
                results["naps"] = report
            }
            
            if let report = negativeInsightsForFeeds(feeds: feeds ?? []) {
                results["feeds"] = report
            }
            
            if let report = negativeInsightsForBottles(bottles: bottles ?? []) {
                results["bottle_feeds"] = report
            }
        }else {
            if let report = positiveInsightsForNaps(naps: naps ?? []) {
                results["naps"] = report
            }
            
            if let report = positiveInsightsForFeeds(feeds: feeds ?? []) {
                results["feeds"] = report
            }

            if let report = positiveInsightsForBottles(bottles: bottles ?? []) {
                results["bottle_feeds"] = report
            }
        }
        
        return results.values.count > 0 ? results : nil
    }
    
    func getTimeDetails<T: Trackable>(items: [T]) -> (count: Int, total: Duration, average: Duration) {
        guard items.count > 0 else {
            return (count: 0, total: 0, average: 0)
        }
        let duration = items.reduce(into: 0) { total, item in
            total += item.trackableUnit
        }
        
        let average = duration / Int32(items.count)
        
        return (count: items.count, total: duration, average: average)
    }
    
    func negativeInsightsForNaps(naps: [Nap]) -> [String]? {
        let details = getTimeDetails(items: naps)
        
        var reports: [String] = []
        
        if details.total > 8 {
            reports.append("over_napping")
        }
        
        if details.total < 4 {
            reports.append("under_napping")
        }
        
        return reports.count > 0 ? reports : nil
    }
    
    func negativeInsightsForFeeds(feeds: [FeedSession]) -> [String]? {
        let details = getTimeDetails(items: feeds)
        let tenMinutes = 60000
        
        var reports: [String] = []
        
        if details.count >= 20 && details.average < tenMinutes {
            reports.append("cluster_feeding")
        }
        
        let earlyMorningFeeds = feeds.filter {$0.wrappedCreatedAt.earlyMorning}.count
        if earlyMorningFeeds > 4 {
            reports.append("late_nights")
        }
        
        if details.average > tenMinutes * 4 {
            reports.append("long_feeds")
        }
        
        return reports.count > 0 ? reports : nil
    }
    
    func negativeInsightsForBottles(bottles: [BottleFeed]) -> [String]? {
        var reports: [String] = []
        
        let earlyMorningFeeds = bottles.filter {$0.wrappedCreatedAt.earlyMorning}.count
        if earlyMorningFeeds > 4 {
            reports.append("late_night_bottles")
        }
        
        return reports.count > 0 ? reports : nil
    }
    
    func positiveInsightsForNaps(naps: [Nap]) -> [String]? {
        let details = getTimeDetails(items: naps)
        let tenMinutes: Double = 60000
        
        var reports: [String] = []
        
        if (4...8).contains(details.count) {
            reports.append("ideal_nap_amount")
        }
        
        if ((tenMinutes * 1.5)...(tenMinutes * 5)).contains(Double(details.average)) {
            reports.append("ideal_nap_duration")
        }
        
        return reports.count > 0 ? reports : nil
    }
    
    func positiveInsightsForFeeds(feeds: [FeedSession]) -> [String]? {
        let details = getTimeDetails(items: feeds)
        let tenMinutes: Double = 60000
        
        var reports: [String] = []
        
        if ((tenMinutes * 1.5)...(tenMinutes * 5)).contains(Double(details.average)) {
            reports.append("ideal_feeding_time")
        }
        
        let earlyMorningFeeds = feeds.filter {$0.wrappedCreatedAt.earlyMorning}.count
        if (1..<4).contains(earlyMorningFeeds) {
            reports.append("ideal_late_nights")
        }
        
        return reports.count > 0 ? reports : nil
    }
    
    func positiveInsightsForBottles(bottles: [BottleFeed]) -> [String]? {
        var reports: [String] = []
        
        let earlyMorningFeeds = bottles.filter {$0.wrappedCreatedAt.earlyMorning}.count
        if (1..<4).contains(earlyMorningFeeds) {
            reports.append("ideal_late_night_bottles")
        }
        
        return reports.count > 0 ? reports : nil
    }
}

struct ParentEmotionInsightsView: View {
    @Environment(\.managedObjectContext) var moc
    @State var generatingReport: Bool = false
    @State var report: InsightReport?
    
    var emotion: Emotion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
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
        }
        .padding()
        .navigationBarTitle("Insights")
        .onAppear {
            let reportGenerator = EmotionInsightsGenerator(emotion: emotion, context: self.moc)
            self.generatingReport = true
            
            Dispatch.background {
                let report = reportGenerator.generate()
                print(report)
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
