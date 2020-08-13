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
                        image: Image(uiImage: child.wrappedImage),
                        color: child.theme.0,
                        lineWidth: 6,
                        layout: self.layout
                    )
                    
//                    Text("\(child.wrappedName)")
//                        .font(.subheadline)
//                        .foregroundColor(Color(UIColor.systemGray))
                }.onTapGesture {
                    try? child.startNewFeedSession()
                    self.profile.objectWillChange.send()
                    self.profile.setOffsetForLayout(layout: self.layout)
                }
            }
        }
    }
    
    @ViewBuilder func feedTimersList() -> some View {
        if self.layout == .expanded {
            VStack {
                FeedSessionsList(
                    profile: self.profile, layout: self.$layout
                )
            }
        }else {
            HStack {
                FeedSessionsList(
                    profile: self.profile, layout: self.$layout
                )
            }
        }
    }
    
    var useVerticalLayout: Bool {
        return self.layout == .expanded //|| !self.profile.multipleWaiting
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Rectangle()
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .foregroundColor(Color.gray.opacity(0.5))
                    .frame(width: 40, height: 6)
            }
            .padding()
            .animation(.interactiveSpring(response: 0.1, dampingFraction: 0.8, blendDuration: 0.1))
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
                    
                    self.profile.setOffsetForLayout(layout: self.layout)
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

                    self.profile.setOffsetForLayout(layout: self.layout)
                }
            )
            
            if self.useVerticalLayout {
                VStack(spacing: 10) {
                    if self.profile.parent.currentFeedSessions.count < 2 {
                        self.childActionsList()
                    }

                    feedTimersList()
                }
                .padding([.leading, .trailing])
                .padding(.bottom, 20)
            }else {
                HStack(spacing: 10) {
                    feedTimersList()

                    if self.profile.parent.currentFeedSessions.count < 2 {
                        self.childActionsList()
                    }
                }
                .padding([.leading, .trailing], 10)
                .padding(.bottom, 10)
            }
        }
        .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.5, blendDuration: 0.5))
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground).opacity(0.5))
        .onAppear {
            self.profile.setOffsetForLayout(layout: self.layout)
        }
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
            .padding(5)
        }
    }
}
