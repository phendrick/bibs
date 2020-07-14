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
    var itemSize: CGSize
    
    init(delegate: CalendarHeatmapDelegate, itemSize: CGSize) {
        self.delgate = delegate
        self.itemSize = itemSize
    }
    
    func makeUIView(context: UIViewRepresentableContext<HeatmapView>) -> CalendarHeatmap {
        let date = Calendar.current.date(byAdding: .month, value: -5, to: Date())!
        
        let startDate = date.startOfMonth
        let endDate   = date.endOfMonth
        
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
        config.itemCornerRadius = 0
        config.allowItemSelection = true
        config.interitemSpacing = 5
        config.itemSize = self.itemSize
        
        let heatmap = CalendarHeatmap(config: config, startDate: startDate, endDate: endDate)
        heatmap.delegate = self.delgate
        
        return heatmap
    }
    
    func updateUIView(_ uiView: CalendarHeatmap, context: Context) {
        uiView.reload()
    }
}
