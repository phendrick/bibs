//
//  DashboardToolsView.swift
//  bibs
//
//  Created by Paul Hendrick on 28/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import SwiftUIPager

struct DashboardToolsView: View {
    @EnvironmentObject var toolsData: ToolsData
    
    var outerGeometry: GeometryProxy
    
    @Binding var activeFeedTool: FeedTool
    @State var page = 0
    
    var body: some View {
        VStack {
            Pager(page: self.$page, data: toolsData.data, id: \.self) { item in
                DashboardToolCardView(
                    image: item.image,
                    title: item.title,
                    subtitle: item.subtitle
                )
            }
            .expandPageToEdges()
            .rotation3D()
            .onPageChanged({ (page) in
                withAnimation {
                    self.page = page
                }
            })
            .frame(
                width: min(self.outerGeometry.size.height, self.outerGeometry.size.width),
                height: min(self.outerGeometry.size.height * 0.6, 400)
            )
            
            HStack(spacing: 15) {
                ForEach(cardData.indices) {index in
                    Rectangle()
                        .frame(width: self.page == index ? 40 : 20, height: 20)
                        .cornerRadius(.infinity)
                        .foregroundColor(Color.gray.opacity(self.page == index ? 0.8 : 0.2))
                        .onTapGesture {
                            withAnimation {
                                self.page = index
                            }
                        }
                }.animation(
                    Animation.interactiveSpring(
                        response: 0.2,
                        dampingFraction: 0.75,
                        blendDuration: 0.5).delay(0.2)
                )
            }
            .frame(width: CGFloat(20 * cardData.count), height: 10)
        }
    }
}

struct DashboardToolCardView: View {
    var image: String
    var title: String
    var subtitle: String
    
    @State var visible = false
    @State var active  = false
    
    var body: some View {
        return ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                HStack {
                    Spacer()
                    
                    Image(self.image)
                        .resizable()
                        .scaledToFit()
                    Spacer()
                }.frame(maxHeight: .infinity)
            }
            
            HStack {
                VStack {
                    Spacer()
                    
                    Text(title)
                        .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                        .padding(5)
                        .padding([.top, .leading, .trailing], 10)
                        .font(.custom("Merriweather-Regular", size: 26))
                    
                    Text(subtitle)
                        .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                        .padding(5)
                        .padding([.leading, .trailing], 10)
                        .font(.custom("OpenSans-Regular", size: 14))
                        .shadow(color: .white, radius: 1, x: 0, y: 0)
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DashboardToolsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GeometryReader { geometry in
                DashboardToolCardView(
                    image: "page1",
                    title: "Feed timers",
                    subtitle: "Feed timers subtitle"
                ).environmentObject(ToolsData())
            }.previewLayout(.fixed(width: 300, height: 380))
        }
    }
}
