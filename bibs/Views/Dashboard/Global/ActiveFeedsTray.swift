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
        
        var previous: ExpandedState? {
            switch(self) {
            case .minimised: return nil
            case .expanded: return .minimised
            }
        }
        
        var next: ExpandedState? {
            switch(self) {
            case .minimised: return .expanded
            case .expanded: return nil
            }
        }
        
        var description: String {
            switch(self) {
            case .minimised: return "minimised"
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
            VStack(spacing: 20) {
                FeedSessionsList(
                    children: self.profile.parent.breastfeedingChildrenArray,
                    layout: self.$layout,
                    profile: self.profile
                )
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
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
    
    var useVerticalLayout: Bool {
        return self.layout == .expanded
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
                        .offset(y: -8)
                }

                if self.useVerticalLayout {
                    VStack(spacing: 10) {
                        feedTimersList()
                    }
                    .frame(maxWidth: .infinity)
                }else {
                    HStack(alignment: .top, spacing: 10) {
                        feedTimersList()
                    }
                }
            }
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemGray6).opacity(0.85))
        }
        .animation(.easeOut)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 140)
        .frame(alignment: .bottom)
        .offset(y: 20)
        .gesture(
            DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .onChanged {translation in
                let dragDirection: DragDirection = (translation.location.y < translation.startLocation.y)
                                   ? .up
                                   : .down
                
                if dragDirection == .up, let layout = self.layout.next {
                    self.layout = layout
                }else if dragDirection == .down, let layout = self.layout.previous {
                    self.layout = layout
                }
            }
            .onEnded { translation in
                let dragDirection: DragDirection = (translation.location.y < translation.startLocation.y)
                ? .up
                : .down

                if dragDirection == .up {
                    self.layout = self.layout.next ?? self.layout
                }else {
                    self.layout = self.layout.previous ?? self.layout
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
            minWidth = UIScreen.main.bounds.size.width * 0.6
        }
        
        if children.count > 3 {
            return max(width, minWidth)
        }else {
            return width
        }
    }
    
    var body: some View {
        ForEach(self.children, id: \.self) {child in
            DashboardFeedTimerView(
                child: child,
                layout: self.$layout,
                cofeeding: self.profile.activeFeedSessions.count>1
            )
            .frame(maxWidth: .infinity)
            .frame(width: cardWidth(child: child))
            .frame(alignment: .bottom)
        }
    }
}
