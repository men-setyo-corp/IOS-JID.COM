//
//  CombineChart.swift
//  JID.COM
//
//  Created by Panda on 26/09/23.
//

import DGCharts
import SwiftUI
import Foundation

struct CombinedChart: UIViewRepresentable {
    var barEntries : [BarChartDataEntry]
    var lineEntries : [ChartDataEntry]
    @Binding var quarter: Int
    func makeUIView(context: Context) -> CombinedChartView {
        return CombinedChartView()
    }
    
    func updateUIView(_ uiView: CombinedChartView, context: Context) {
        setChartData(uiView)
        configureChart(uiView)
        formatXAxis(uiView.xAxis)
        formatLeftAxis(uiView.leftAxis)
        formatRightAxis(uiView.rightAxis)
        uiView.notifyDataSetChanged()
    }
    
    func setChartData(_ combinedChart: CombinedChartView) {
        let barDataSet = BarChartDataSet(entries: barEntries)
        let barChartData = BarChartData(dataSet: barDataSet)
        let lineDataSet = LineChartDataSet(entries: lineEntries)
        let lineChartData = LineChartData(dataSet: lineDataSet)
        let data = CombinedChartData()
        data.lineData = lineChartData
        data.barData = barChartData
        combinedChart.data = data
        formatLineChartDataSet(lineDataSet)
        formatBarChartDataSet(barDataSet)
    }
    
    func formatLineChartDataSet(_ lineDataSet: LineChartDataSet) {
        lineDataSet.label = "Revenue"
        lineDataSet.setColor(.systemIndigo)
        lineDataSet.lineWidth = 2.5
        lineDataSet.setCircleColor(.systemIndigo)
        lineDataSet.circleRadius = 5
        lineDataSet.circleHoleRadius = 0
        let dataSetFormatter = NumberFormatter()
        dataSetFormatter.numberStyle = .currency
        dataSetFormatter.maximumFractionDigits = 0
        lineDataSet.valueFormatter = DefaultValueFormatter(formatter: dataSetFormatter)
        lineDataSet.valueFont = .boldSystemFont(ofSize: 10)
        lineDataSet.valueTextColor = .systemIndigo
        lineDataSet.axisDependency = .right
    }

    func formatBarChartDataSet( _ barDataSet: BarChartDataSet) {
        barDataSet.label = "Units Sold"
        barDataSet.colors = [UIColor.systemPurple]
        barDataSet.valueTextColor = UIColor.white
        barDataSet.valueFont = .boldSystemFont(ofSize: 10)
        barDataSet.axisDependency = .left
        barDataSet.highlightAlpha = 0
    }
    
    func configureChart(_ combinedChart: CombinedChartView) {
        combinedChart.noDataText = "No Data"
        combinedChart.drawValueAboveBarEnabled = false
        combinedChart.setScaleEnabled(false)
        combinedChart.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .linear)
        if combinedChart.scaleX == 1.0 && quarter == 0 {
            combinedChart.zoom(scaleX: 1.5, scaleY: 1, x: 0, y: 0)
        } else {
            combinedChart.fitScreen()
        }
        let marker:CombinedMarker = CombinedMarker(color: UIColor.blue, font: UIFont(name: "Helvetica", size: 12)!, textColor: UIColor.white, insets: UIEdgeInsets(top: 7.0, left: 7.0, bottom: 7.0, right: 7.0), quarter: quarter)
        marker.minimumSize = CGSize(width: 75, height: 35)
        combinedChart.marker = marker
    }
    
    func formatXAxis(_ xAxis: XAxis) {
        xAxis.labelPosition = .bottom
        xAxis.axisMinimum = -0.5
        xAxis.axisMaximum = Double(barEntries.count) - 0.5
        xAxis.granularity = 1
        xAxis.valueFormatter = IndexAxisValueFormatter(values: Sale.monthsToDisplayForQuarter(quarter))
        xAxis.labelTextColor =  UIColor.label
    }

    func formatLeftAxis(_ leftAxis: YAxis) {
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.numberStyle = .none
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = (barEntries.map{$0.y}.max() ?? 0) + 20
        leftAxis.labelTextColor =  .red
    }

    func formatRightAxis(_ rightAxis: YAxis) {
        let rightAxisFormatter = NumberFormatter()
        rightAxisFormatter.numberStyle = .currency
        rightAxisFormatter.maximumFractionDigits = 0
        rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: rightAxisFormatter)
        rightAxis.axisMinimum = 0
        rightAxis.axisMaximum = (lineEntries.map{$0.y}.max() ?? 0) + 150
        rightAxis.labelTextColor =  .red
    }
}



struct CombinedChart_Previews: PreviewProvider {
    static var previews: some View {
        CombinedChart(barEntries: Sale.UnitsFor(Sale.allSales, quarter: 0), lineEntries: Sale.TransactionsFor(Sale.allSales, quarter: 0), quarter: .constant(0))
    }
}

struct Sale {
    enum Month:Int {
        case jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
    }
    
    let month: Month
    let units: Double
    let transaction: Double
    var quarter: Int {
        switch month {
        case .jan, .feb, .mar:
            return 1
        case .apr, .may, .jun:
            return 2
        case .jul, .aug, .sep:
            return 3
        default:
            return 4
        
        }
    }
    var xValue: Double {
        Double(month.rawValue)
    }
    
    static func UnitsFor(_ sales: [Sale], quarter: Int) -> [BarChartDataEntry] {
        var quarterlySales = sales
        var adjustment = 0
        if quarter != 0 {
            quarterlySales = sales.filter{$0.quarter == quarter}
            adjustment = 3 * quarter - 3
        }
        
        return quarterlySales.map { BarChartDataEntry(x: $0.xValue - Double(adjustment), y: $0.units)}
    }
    
    static func TransactionsFor(_ sales: [Sale], quarter: Int) -> [ChartDataEntry] {
        var quarterlySales = sales
        var adjustment = 0
        if quarter != 0 {
            quarterlySales = sales.filter{$0.quarter == quarter}
            adjustment = 3 * quarter - 3
        }
        return quarterlySales.map { ChartDataEntry(x: $0.xValue - Double(adjustment), y: $0.transaction)}
    }
    
    
    static func monthsToDisplayForQuarter(_ quarter: Int) -> [String] {
        let months =  ["Jan","Feb","Mar","Apr","May","Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        switch quarter {
        case 0:
            return months
        case 1:
            return Array(months[0..<3])
        case 2:
            return Array(months[3..<6])
        case 3:
            return Array(months[6..<9])
        default:
            return Array(months[9..<12])
        }
    }
 
    static var allSales: [Sale] {
        [
            Sale(month: .jan, units: 50, transaction: 2500),
            Sale(month: .feb, units: 100, transaction: 5000),
            Sale(month: .mar, units: 30, transaction: 1500),
            Sale(month: .apr, units: 110, transaction: 5100),
            Sale(month: .may, units: 90, transaction: 4200),
            Sale(month: .jun, units: 150, transaction: 7500),
            Sale(month: .jul, units: 25, transaction: 1250),
            Sale(month: .aug, units: 200, transaction: 9000),
            Sale(month: .sep, units: 15, transaction: 750),
            Sale(month: .oct, units: 200, transaction: 6000),
            Sale(month: .nov, units: 45, transaction: 2100),
            Sale(month: .dec, units: 100, transaction: 6000)
            
        ]
    }
    
}
