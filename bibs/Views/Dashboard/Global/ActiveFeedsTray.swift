//
//  Used on the dashboard when the currently active tool is not the feeds tool 
//
//
//  SwiftUIView.swift
//  bibs
//
//  Created by Paul Hendrick on 07/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ActiveFeedsTrayView: View {
    @ObservedObject var profile: ProfileObserver
    @State var layout: ExpandedState = .minimised
    @State var dragDirection: DragDirection = .up
    
    enum ExpandedState: CaseIterable {
        case minimised
        case expanded
        case single
        
        var previous: ExpandedState? {
            switch(self) {
            case .single, .minimised: return nil
            case .expanded: return .minimised
            }
        }
        
        var next: ExpandedState? {
            switch(self) {
            case .single, .minimised: return .expanded
            case .expanded: return nil
            }
        }
        
        var description: String {
            switch(self) {
            case .single, .minimised: return "minimised"
            case .expanded: return "expanded"
            }
        }
    }
    
    enum DragDirection {
        case up
        case down
    }
    
    @ViewBuilder func feedTimersList() -> some View {
        if self.layout == .expanded {
            VStack(spacing: 10) {
                FeedSessionsList(
                    children: self.profile.parent.breastfeedingChildrenArray,
                    layout: self.$layout,
                    profile: self.profile
                )
                .padding(10)
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
        }else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    FeedSessionsList(
                        children: self.profile.parent.breastfeedingChildrenArray,
                        layout: self.$layout,
                        profile: self.profile
                    )
                }.padding(10)
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack(alignment: .top) {
                    Rectangle()
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .foregroundColor(Color.gray.opacity(0.5))
                        .frame(width: 40, height: 6)
                        .padding(.top)
                        .fixedSize()
                }

                feedTimersList()
            }
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemGray6).opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .frame(alignment: .bottom)
        .offset(y: 20)
        .gesture(
            DragGesture(minimumDistance: 10, coordinateSpace: .global)
                .onChanged {translation in
                    guard self.layout != .single else {
                        return
                    }
                    
                    let dragDirection: DragDirection = (translation.location.y < translation.startLocation.y)
                                       ? .up
                                       : .down
                    
                    if dragDirection == .up, let layout = self.layout.next {
                        self.layout = layout
                    }else if dragDirection == .down, let layout = self.layout.previous {
                        self.layout = layout
                    }
                }
        )
    }
}

struct ActiveFeedsTrayView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveFeedsTrayView(profile: ProfileObserver.shared)
            .previewLayout(.fixed(width: 480, height: 300))
    }
}

struct FeedSessionsList: View {
    var children: [Child]
    @Binding var layout: ActiveFeedsTrayView.ExpandedState
    @ObservedObject var profile: ProfileObserver
    
    func cardWidth(child: Child) -> CGFloat {
        guard self.layout != ActiveFeedsTrayView.ExpandedState.expanded else {
            return UIScreen.main.bounds.size.width * 0.9
        }
        
        let padding = 10 + (5 * (children.count - 1))
        var width = (UIScreen.main.bounds.size.width - CGFloat(padding * 2)) / CGFloat(children.count)
        
        if children.count > 2 {
            width = UIScreen.main.bounds.size.width / 2.4
        }
        
        var minWidth: CGFloat = 100
        
        if let _ = child.activeFeedSession {
            minWidth = UIScreen.main.bounds.size.width * 0.5
        }
        
        if children.count > 2 {
            return max(width, minWidth)
        }else {
            return width
        }
    }
    
    var body: some View {
        let children = self.layout == .expanded ? Array(self.children.prefix(5)) : self.children
        
        return ForEach(children, id: \.self) {child in
            DashboardFeedTimerView(
                child: child,
                layout: self.$layout,
                cofeeding: self.profile.activeFeedSessions.count>1,
                siblingCount: self.profile.parent.breastfeedingChildrenArray.count
            )
            .frame(maxWidth: .infinity)
            .frame(width: cardWidth(child: child))
            .frame(alignment: .bottom)
        }
    }
}
