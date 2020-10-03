//
//  PlaygroundView.swift
//  bibs
//
//  Created by Paul Hendrick on 12/09/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct ChildObject: Hashable {
    var name: String
    var color: Color
    var feeding: Bool = false
    
    init(name: String, color: Color, feeding: Bool) {
        self.name = name
        self.color = color
        self.feeding = feeding
    }
}

enum TimerLayout {
    case compact
    case full
}

struct ChildTimerView: View {
    var baby: ChildObject
    @Binding var timerLayout: TimerLayout
    @Binding var feedCount: Int
    
    var fontSize: CGFloat {
        self.timerLayout == .compact ? 12 : 16
    }
    
    var horizontalAlignment: HorizontalAlignment {
        self.timerLayout == .compact ? .leading : .center
    }
    
    var containerAlignment: Alignment {
        self.timerLayout == .compact ? .leading : .center
    }
    
    var body: some View {
        VStack(alignment: horizontalAlignment) {
            HStack(alignment: .firstTextBaseline, spacing: 20) {
                Text(baby.name)
                
                if self.timerLayout == .compact {
                    Text("00:22:04.11").font(.custom("RobotoMono-Regular", size: fontSize))
                    
                    Image(systemName: "pause")
                }
            }.font(.system(size: fontSize))
            
            if self.timerLayout == .full {
                HStack(alignment: .firstTextBaseline, spacing: 20) {
                    Text("00:11:04.11").font(.custom("RobotoMono-Regular", size: fontSize))
                    Image(systemName: "pause").font(.system(size: fontSize * 0.8))
                    Text("Left").font(.custom("RobotoMono-Regular", size: fontSize * 0.8))
                }.frame(maxWidth: .infinity, alignment: containerAlignment)
            }
        }
        .padding(5)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: self.timerLayout == .compact ? 60 : 150)
        .background(baby.color)
    }
}

struct PlaygroundView: View {
    @State var from: Date = Date()
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    
    @State var layout: TimerLayout = .compact
    
    @State var dateFilterStartDate: Date = Date()
    @State var dateFilterEndDate: Date = Date()
    
    let babies: [ChildObject] = [
//        ChildObject(name: "Milo", color: .red, feeding: true),
        ChildObject(name: "Tabitha", color: .green, feeding: true),
        ChildObject(name: "Gus", color: .orange, feeding: false)
    ]
    
    var body: some View {
//        VStack(spacing: 15) {
//            Spacer()
//
//            HStack {
//                Rectangle().frame(width: 80, height: 5).foregroundColor(Color.gray.opacity(0.5)).cornerRadius(10).onTapGesture {
//                    print("Switching layout")
//                    self.layout = self.layout == .compact ? .full : .compact
//                }
//            }
//
//            HStack(spacing: 0) {
//                ForEach(babies, id: \.self) { baby in
//                    ChildTimerView(baby: baby, timerLayout: self.$layout, feedCount: .constant(2))
//                }
//            }
//            .frame(maxWidth: .infinity)
//        }
//        .edgesIgnoringSafeArea(.bottom)
//        .frame(alignment: .bottom)
//        .background(Color.white)
//        .font(.caption)
//        .padding(.top)
        
        VStack(spacing: 50) {
            Section(header: Text("Date from")) {
                DatePicker(selection: self.$dateFilterStartDate, displayedComponents: .date) {
                    Text("")
                }.labelsHidden()
            }
            
            Section(header: Text("Date to")) {
                DatePicker(selection: self.$dateFilterEndDate, displayedComponents: .date) {
                    Text("")
                }.labelsHidden()
            }
            
            Button("Done") {
            }
            
        }
    }
}

struct PlaygroundView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlaygroundView()
                .previewLayout(.fixed(width: 420, height: 200))
        }
    }
}
