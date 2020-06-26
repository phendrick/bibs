//
//  DashboardView.swift
//  bibs
//
//  Created by Paul Hendrick on 25/05/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import Introspect
import CoreData

enum FeedTool: Int, CaseIterable {
    case FeedTimer
    case NappyChange
    case ExpressedFeed
}

class CustomScrollViewDelegate: NSObject, UIScrollViewDelegate {
    var scrollViewDidEndDeceleratingCallback: (Int) -> Void
    var pageWidth: CGFloat = 0
    var pageCount: Int = 0
    
    init(scrollViewDidEndDeceleratingCallback: @escaping (Int) -> Void) {
        self.scrollViewDidEndDeceleratingCallback = scrollViewDidEndDeceleratingCallback
        
        super.init()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetIndex = Int(scrollView.contentOffset.x / CGFloat(pageWidth))
        
        self.scrollViewDidEndDeceleratingCallback(offsetIndex)
    }
}

struct DashboardView: View {
    @State private var childSheetVisible: Bool = false
    
    @EnvironmentObject var activeChildProfile: ActiveChildProfile
    @ObservedObject var viewSettings = ViewSettings()
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(
        entity: FeedSession.entity(),
        sortDescriptors: [],
        predicate: NSPredicate(
            format: "state == %@", NSNumber(
                value: FeedSession.FeedSessionStatus.running.rawValue
            )
        ),
        animation: .spring()) var activeFeedSessions: FetchedResults<FeedSession>
    
    @State var activeFeedTool: FeedTool = .FeedTimer
    @State var hello: String = "Whoo!"
    
    var scrollViewDelegate: CustomScrollViewDelegate!
    
    init() {
        self.scrollViewDelegate = CustomScrollViewDelegate(scrollViewDidEndDeceleratingCallback: updatePageIndex)
    }
    
    func updatePageIndex(index: Int) {
        guard let tool = FeedTool(rawValue: index) else {
            return
        }
        
        self.activeFeedTool = tool
    }
    
    var body: some View {
        GeometryReader {outerGeometry in
            NavigationView {
                VStack {
                    ZStack {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                Text("feed")
                                    .frame(width: outerGeometry.size.width, height: outerGeometry.size.width*0.5)
                                    .background(Color.orange)

                                Text("nappy")
                                    .frame(width: outerGeometry.size.width, height: outerGeometry.size.width*0.5)
                                    .background(Color.red)

                                Text("expressed")
                                    .frame(width: outerGeometry.size.width, height: outerGeometry.size.width*0.5)
                                    .background(Color.orange)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.yellow)
                        .animation(.spring(response: 0.6, dampingFraction: 0.6, blendDuration: 1))
                        .introspectScrollView { (scrollView) in
                            self.scrollViewDelegate.pageWidth = outerGeometry.size.width
                            self.scrollViewDelegate.pageCount = FeedTool.allCases.count
                            
                            scrollView.isPagingEnabled = true
                            scrollView.delegate = self.scrollViewDelegate
                            self.scrollViewDelegate.scrollViewDidEndDeceleratingCallback = self.updatePageIndex
                        }
                        
                        Divider()
                        
                        HStack(alignment: .bottom) {
                            Spacer()
                            
                            ForEach(FeedTool.allCases.indices) {index in
                                Text("\(index)")
                                    .padding()
                                    .background(self.activeFeedTool.rawValue == index ? Color.pink : Color.clear)
                            }
                        }
                    }
                    .background(Color.green)

                    Divider()

                    if self.activeFeedTool == .FeedTimer {
                        DashboardDataView(title: "Feeds") { (result: FeedSession, index) in
                            Text(result.formattedElapsedTime())
                                .padding(.leading, 0)
                        }
                        
                        Button(action: {
                            print("Start new feed")
                        }) {
                            HStack {
                                Text("Start Timer")
                                Spacer()
                            }.padding()
                        }
                    }

                    if self.activeFeedTool == .NappyChange {
                        DashboardDataView(title: "Nappy Changes") { (result: FeedSession, index) in
                            Text("\(result.status.rawValue)")
                        }
                    }

                    if self.activeFeedTool == .ExpressedFeed {
                        DashboardDataView(title: "Expressed Feed") { (result: FeedSession, index) in
                            Text("\(result.duration)")
                        }
                    }

                    Spacer()
                }
                .navigationBarTitle("Morning")
                .navigationBarItems(
                    leading:  Image(systemName: "person.crop.circle").foregroundColor(.orange),
                    trailing: Image("heart").resizable().frame(width: 40, height: 40)
                )
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return DashboardView()
            .environment(\.managedObjectContext, context)
            .environmentObject(ActiveChildProfile.shared)
    }
}
