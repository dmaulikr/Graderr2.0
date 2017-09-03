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
    
    
    
    static func createLineChart(answersOverTime : [(date: Date, answerSum: Double)], lineChartView : LineChartView) {
        
        
        //lineChartView.delegate = self
        // 2
        lineChartView.chartDescription?.text = "Tap node for details"
        // 3
        lineChartView.chartDescription?.textColor = UIColor.white
        lineChartView.gridBackgroundColor = UIColor.darkGray
        // 4
        lineChartView.noDataText = "No data provided"
        // 1 - creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for i in 0 ..< answersOverTime.count {
            yVals1.append(ChartDataEntry(x: Double(i), y: answersOverTime[i].answerSum))
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "Avg Reviews")
        set1.axisDependency = .left // Line will correlate with left axis values
        set1.setColor(UIColor.red.withAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(UIColor.red) // our circle will be dark red
        set1.lineWidth = 2.0
        set1.circleRadius = 6.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.fillColor = UIColor.red
        set1.highlightColor = UIColor.white
        set1.drawCircleHoleEnabled = true
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        //LineChartData.init
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setDrawValues(true)
        //5 - finally set our data
        lineChartView.data = data
        lineChartView.xAxis.valueFormatter = XValsFormatter(xVals: answersOverTime.map{Utility.dateToString(date: $0.date)})
        lineChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        lineChartView.xAxis.axisMinimum = Double(0)
        lineChartView.xAxis.axisMaximum = Double(answersOverTime.count - 1)
    }

 
}

class XValsFormatter: NSObject, IAxisValueFormatter {
    
    let xVals: [String]
    init(xVals: [String]) {
        self.xVals = xVals
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return xVals[Int(value)]
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
