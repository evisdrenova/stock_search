//
//  create_chart.swift
//  search_auto_complete MessagesExtension
//
//  Created by Evis Drenova on 3/12/21.
//

import Foundation
import Charts
import TinyConstraints


struct create_chart: Codable{

    lazy var linechart: LineChartView = {
         var linechart = LineChartView()
         linechart.backgroundColor = .white
         linechart.rightAxis.enabled = false
         linechart.xAxis.labelPosition = .bottom
         linechart.xAxis.drawGridLinesEnabled = false
         linechart.leftAxis.drawGridLinesEnabled = false
         linechart.legend.enabled = false
         linechart.xAxis.drawAxisLineEnabled = false
         linechart.leftAxis.drawAxisLineEnabled = false
         linechart.xAxis.drawLabelsEnabled = false
         linechart.leftAxis.labelXOffset = 0
         linechart.leftAxis.decimals = 0


         return linechart
     }()

    mutating func createChart( chartdata: [ChartDataEntry], comp: (UIImage)-> ()){

        let set1 = LineChartDataSet(entries: chartdata)
        set1.drawCirclesEnabled = false
        set1.drawCirclesEnabled = false
        set1.mode = .cubicBezier
        set1.lineWidth = 3
        set1.setColor(.systemBlue)
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemBlue


        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        self.linechart.data = data
        
        
        let customView: UIView =  UIView(frame: CGRect(x: 0, y: 0, width: 363, height: 363))
        customView.addSubview(linechart)
//        customView.addSubview(customView)
        linechart.centerInSuperview()
        linechart.width(to: customView)
        linechart.heightToWidth(of: customView)
        
        let renderer = UIGraphicsImageRenderer(size: customView.bounds.size)
        let image = renderer.image{ ctx in customView.drawHierarchy(in: customView.bounds, afterScreenUpdates: true)}
        
        comp(image)
    }

    }
