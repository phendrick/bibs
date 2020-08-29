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
    @State var dragOffset: CGPoint = .zero
    @State var dragDirection: DragDirection = .up
    @State var isDragging = false
    
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
    
    @ViewBuilder func childActionsList() -> some View {
        HStack(spacing: 10) {
            ForEach(self.profile.parent.childrenWithoutCurrentFeedSessions) { child in
                VStack {
                    AvatarImageView(
                        image: Image("baby"),
                        color: child.theme.0,
                        lineWidth: 6,
                        layout: self.layout
                    )
                }.onTapGesture {
                    try? child.startNewFeedSession()
                    self.profile.objectWillChange.send()
                }
            }
        }
        .frame(height: 100)
    }
    
    @ViewBuilder func feedTimersList() -> some View {
        if self.layout == .expanded {
            VStack(spacing: 20) {
                FeedSessionsList(
                    profile: self.profile, layout: self.$layout
                )
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
        }else {
            HStack(spacing: 10) {
                FeedSessionsList(
                    profile: self.profile, layout: self.$layout
                )
            }
        }
    }
    
    var useVerticalLayout: Bool {
        return self.layout == .expanded
    }
    
    var showActions: Bool {
        let childrenNotFeeding = self.profile.parent.childrenWithoutCurrentFeedSessions.count > 0
        
        return childrenNotFeeding && self.profile.parent.currentFeedSessions.count < 2
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
                        if showActions {
                            self.childActionsList()
                        }

                        feedTimersList()
                    }
                    .frame(maxWidth: .infinity)
                }else {
                    HStack(alignment: .top, spacing: 10) {
                        feedTimersList()

                        if showActions {
                            self.childActionsList()
                        }
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground).opacity(0.75))
        }
        .animation(.easeInOut)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 140)
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
                
                print("Drag ended - set offset height")
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
    @ObservedObject var profile: ProfileObserver
    @Binding var layout: ActiveFeedsTrayView.ExpandedState
    
    var body: some View {
        ForEach(self.profile.parent.currentFeedSessions, id: \.self) {session in
            DashboardFeedTimerView(
                profile: self.profile,
                feedSession: session,
                color: Color.green,
                layout: self.$layout,
                cofeeding: self.profile.parent.currentFeedSessions.count>1
            )
            .frame(minHeight: 70)
            .frame(maxHeight: self.layout == .expanded ? 140 : 100)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
        }
    }
}
