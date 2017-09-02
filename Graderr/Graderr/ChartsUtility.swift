//
//  GraphUtility.swift
//  Graderr
//
//  Created by Sean Strong on 8/31/17.
//  Copyright © 2017 Sean Strong. All rights reserved.
//

import Foundation
import Charts

struct ChartsUtility {
    
    static func createPieChart(values : [(label :String, value: Double)], pieChartView : PieChartView) {
        
        var entries = [PieChartDataEntry]()
        for (index, value) in values.map({$0.value}).enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = values.map({$0.label})[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for i in 0..<values.count {
            let blue = Double((126/values.count * (i + 1) + 100))
            let color = UIColor(red: CGFloat(50), green: CGFloat(blue/2/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        data.setValueFormatter(DigitValueFormatter())
        pieChartView.data = data
        pieChartView.noDataText = "No data available"
        // user interaction
        pieChartView.isUserInteractionEnabled = true
        let d = Description()
        d.text = "Graderr"
        pieChartView.chartDescription = d
        
    }
 
}

class DigitValueFormatter : NSObject, IValueFormatter {
    
    func stringForValue(_ value: Double,
                        entry: ChartDataEntry,
                        dataSetIndex: Int,
                        viewPortHandler: ViewPortHandler?) -> String {
        let valueWithoutDecimalPart = String(format: "%.0f", value)
        return "\(valueWithoutDecimalPart)"
    }
}
