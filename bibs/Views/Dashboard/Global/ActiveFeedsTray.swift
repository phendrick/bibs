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
    @State var expanded: ExpandedState = .minimised
    @State var dragOffset: CGPoint = .zero
    @State var dragDirection: DragDirection = .up
    @State var isDragging = false
    
    enum ExpandedState: CaseIterable {
        case minimised
        case minimal
        case expanded
        
        var previous: ExpandedState? {
            switch(self) {
            case .minimised: return nil
            case .minimal: return .minimised
            case .expanded: return .minimal
            }
        }
        
        var next: ExpandedState? {
            switch(self) {
            case .minimised: return .minimal
            case .minimal: return .expanded
            case .expanded: return nil
            }
        }
        
        var description: String {
            switch(self) {
            case .minimised: return "minimisd"
            case .minimal: return "minimal"
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
                        lineWidth: 2
                    )
                    Text("\(child.wrappedName)")
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.systemGray))
                }.onTapGesture {
                    try? child.startNewFeedSession()
                    self.profile.objectWillChange.send()
                }.frame(maxHeight: 100)
            }
        }
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
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .onChanged {translation in
                    self.dragOffset.y = abs(translation.startLocation.y - translation.location.y)
                    
                    guard self.dragOffset.y >= 20 else {
                        return
                    }
                    
                    guard self.profile.parent.currentFeedSessions.count > 0 else {
                        return
                    }
                    
                    let dragDirection: DragDirection = (translation.location.y < translation.startLocation.y)
                        ? .up
                        : .down
                    
                    if dragDirection == .up {
                        self.expanded = .expanded
                    }else {
                        self.expanded = .minimised
                    }
                }.onEnded { translation in
                    var height = 40 + (120 * self.profile.parent.childrenWithoutCurrentFeedSessions.count)
                    height += 120 * self.profile.parent.currentFeedSessions.count
                    
                    if self.expanded != .expanded {
                        height -= 100
                    }
                    
                    self.profile.trayHeight = CGFloat(height)
                }
            )
            
            if self.expanded == .expanded {
                VStack {
                    self.childActionsList()
                    
                    FeedSessionsList(
                        profile: self.profile, expanded: self.$expanded
                    )
                }.padding()
            }else {
                VStack {
                    self.childActionsList()
                    
                    HStack(spacing: 10) {
                        FeedSessionsList(
                            profile: self.profile, expanded: self.$expanded
                        )
                    }.padding()
                }
            }
        }
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5))
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground).opacity(0.5))
        .onAppear {
            var height = 40 + (120 * self.profile.parent.childrenWithoutCurrentFeedSessions.count)
            height += 120 * self.profile.parent.currentFeedSessions.count
            
            if self.expanded != .expanded {
                height -= 100
            }
            
            self.profile.trayHeight = CGFloat(height)
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
    @Binding var expanded: ActiveFeedsTrayView.ExpandedState
    
    var body: some View {
        ForEach(self.profile.parent.currentFeedSessions, id: \.self) {session in
            DashboardFeedTimerView(
                profile: self.profile,
                feedSession: session,
                color: Color.green,
                layout: self.$expanded,
                cofeeding: self.profile.parent.currentFeedSessions.count>1
            ).padding(self.expanded == .expanded ? 10 : 0)
        }
    }
}
