//
//  HeatmapView.swift
//  bibs
//
//  Created by Paul Hendrick on 12/07/2020.
//  Copyright © 2020 Paul Hendrick. All rights reserved.
//

import SwiftUI
import CalendarHeatmap

struct HeatmapView: UIViewRepresentable {
    var delgate: CalendarHeatmapDelegate
    
    init(delegate: CalendarHeatmapDelegate) {
        self.delgate = delegate
    }
    
    func makeUIView(context: UIViewRepresentableContext<HeatmapView>) -> CalendarHeatmap {
        let startDate = Date().startOfMonth
        let endDate   = Date().endOfMonth
        
        var calendarFont: UIFont
        
        var config  = CalendarHeatmapConfig()
        
        if let font = UIFont(name: "RobotoMono-Regular", size: 16) {
            calendarFont = font
        }else {
            calendarFont = config.monthFont
        }
        
        config.weekDayWidth = 0
        config.monthHeight  = 0
        config.monthFont = calendarFont
        config.itemSide = 50
        config.itemCornerRadius = 10
        config.allowItemSelection = true
        config.interitemSpacing = 10
        
        let heatmap = CalendarHeatmap(config: config, startDate: startDate, endDate: endDate)
        heatmap.delegate = self.delgate
        
        return heatmap
    }
    
    func updateUIView(_ uiView: CalendarHeatmap, context: Context) {
        uiView.reload()
    }
}
