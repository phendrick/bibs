//
//  DashboardToolsView.swift
//  bibs
//
//  Created by Paul Hendrick on 28/06/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI

struct DashboardToolsView: View {
    var geometry: GeometryProxy
    @Binding var activeFeedTool: FeedTool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                DashboardToolCardView(
                    image: Image("embryo"),
                    title: "Feeds",
                    color: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
                )
                .padding(.leading, 5)
                .frame(width: geometry.size.width*0.75, height: geometry.size.width*0.75)
                .onTapGesture {
                    self.activeFeedTool = .FeedTimer
                }
                
                DashboardToolCardView(
                    image: Image("nappy"),
                    title: "Nappy Change",
                    color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
                )
                .frame(width: geometry.size.width*0.75, height: geometry.size.width*0.75)
                .onTapGesture {
                    self.activeFeedTool = .NappyChange
                }
                
                DashboardToolCardView(
                    image: Image("bottle"),
                    title: "Expressed Feed",
                    color: Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))
                )
                .frame(width: geometry.size.width*0.75, height: geometry.size.width*0.75)
                .onTapGesture {
                    self.activeFeedTool = .ExpressedFeed
                }
                
                DashboardToolCardView(
                    image: Image("calendar"),
                    title: "Data & Progress",
                    color: Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
                )
                .frame(width: geometry.size.width*1, height: geometry.size.width*0.75)
                .onTapGesture {
                    self.activeFeedTool = .DataOverview
                }
            }
        }
    }
}

struct DashboardToolCardView: View {
    var image: Image
    var title: String
    var color: Color
    
    @State var visible = false
    
    var body: some View {
        let strokeGradient = LinearGradient(
            gradient: Gradient(colors: [color.opacity(0.5), color.opacity(0.2)]), startPoint: .top, endPoint: .bottom
        )
        
        return HStack {
            VStack(alignment: .center) {
                Spacer()
                
                ZStack {
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .shadow(color: color, radius: 60, x: 0, y: 20)
                }
                
                VStack(alignment: .center) {
                    Text(title)
                        .font(.custom("OpenSans-SemiBold", size: 22))
                    Text("1 active feed")
                        .font(.custom("OpenSans-Regular", size: 14))
                        .padding(.top, 10)
                }
                .foregroundColor(color).colorMultiply(.gray)
                .padding(.top, 25)
                .foregroundColor(.white)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10).foregroundColor(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(strokeGradient, lineWidth: 1)
                )
            )
            .cornerRadius(10)
            .padding(15)
        }
        
        .onAppear {
            self.visible = true
        }
    }
}


struct DashboardToolsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GeometryReader { geometry in
                DashboardToolsView(
                    geometry: geometry,
                    activeFeedTool: .constant(.FeedTimer)
                )
            }.previewLayout(.fixed(width: 400, height: 300))
            
            GeometryReader { geometry in
                DashboardToolCardView(
                    image: Image("embryo"),
                    title: "Test",
                    color: Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
                )
            }.previewLayout(.fixed(width: 240, height: 280))
        }
    }
}
