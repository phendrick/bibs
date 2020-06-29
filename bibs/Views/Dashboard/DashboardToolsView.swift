//
//  DashboardToolsView.swift
//  bibs
//
//  Created by Paul Hendrick on 28/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import SwiftUIPager

struct CardModel: Hashable {
    var image: String
    var title: String
    var subtitle: String
}

let cardData:[CardModel] = [
    CardModel(image: "page1", title: "Feed Timers", subtitle: "Monitor your baby's feeds"),
    CardModel(image: "page2", title: "Nappy Change", subtitle: "Log a wet or dirty nappy"),
    CardModel(image: "page3", title: "Expressed Feed", subtitle: "Given some expressed milk?"),
    CardModel(image: "page4", title: "Data & Progress", subtitle: "Charts & Historical data")
]

struct DashboardToolsView: View {
    var geometry: GeometryProxy
    @Binding var activeFeedTool: FeedTool
    @State var page = 0
    
    var scrollViewDelegate: CustomUIScrollViewDelegate!
    
    var body: some View {
        VStack {
            Pager(page: self.$page, data: cardData, id: \.self) {
                DashboardToolCardView(
                    image: $0.image,
                    title: $0.title,
                    subtitle: $0.subtitle
                )
            }
            .expandPageToEdges()
            .onPageChanged({ (page) in
                withAnimation {
                    self.page = page
                }
            })
            .frame(
                width: min(self.geometry.size.height, self.geometry.size.width),
                height: min(self.geometry.size.height * 0.6, 400)
            )
            
            HStack(spacing: 5) {
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
                        dampingFraction: 1,
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
                VStack(alignment: .leading) {
                    Text(title)
                        .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                        .padding(5)
                        .padding([.top, .leading, .trailing], 10)
                        .font(.custom("Merriweather-Regular", size: 26))
                    
                    Spacer()
                    
                    Text(subtitle)
                        .foregroundColor(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                        .padding(5)
                        .padding([.leading, .trailing], 10)
                        .font(.custom("OpenSans-Regular", size: 14))
                        .shadow(color: .white, radius: 1, x: 0, y: 0)
                }

//                Spacer()
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
                )
            }.previewLayout(.fixed(width: 300, height: 380))
        }
    }
}
