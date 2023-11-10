//
//  DashPemeliharaan.swift
//  JID.COM
//
//  Created by Panda on 25/09/23.
//

import Foundation
import SwiftUI
import DGCharts

struct PemeliharaanChartView: UIViewRepresentable {
    
    let entries: [BarChartDataEntry]
    let barChart = BarChartView()
    @Binding var selectedYear: Int
    @Binding var selectedItem: String
    let groupSpace = 0.2
    
    func makeUIView(context: Context) -> BarChartView {
        barChart.delegate = context.coordinator
        return barChart
    }
    
    func updateUIView(_ uiView: BarChartView, context: Context) {
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.label = "Dalam Rencana"
        uiView.noDataText = "No Data"
        uiView.data = BarChartData(dataSet: dataSet)
        uiView.rightAxis.enabled = false
        uiView.fitBars = true
        if selectedYear == -1 {
            uiView.animate(xAxisDuration: 0, yAxisDuration: 0.5, easingOption: .linear)
            uiView.highlightValue(nil, callDelegate: false)
        }
        uiView.setScaleEnabled(false)
        formatDataSet(dataSet: dataSet)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatXAxis(xAxis: uiView.xAxis)
        formatLegend(legend: uiView.legend)
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        let parent: PemeliharaanChartView
        init(parent: PemeliharaanChartView) {
            self.parent = parent
        }
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            let month = DataDashPemeliharaan.months[Int(entry.x)]
            let quantity = Int(entry.y)
            parent.selectedItem = "\(quantity) sold in \(month)"
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func formatDataSet(dataSet: BarChartDataSet) {
        dataSet.colors = [.systemOrange]
        dataSet.valueColors = [.blue]
        dataSet.form = .circle
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        dataSet.valueFormatter = DefaultValueFormatter(formatter: formatter)
    }
    
    func formatLeftAxis(leftAxis: YAxis) {
        leftAxis.labelTextColor = .black
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        leftAxis.axisMinimum = 0
    }
    
    func formatXAxis(xAxis: XAxis) {
//        xAxis.valueFormatter = IndexAxisValueFormatter(values: DataDashPemeliharaan.months)
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .blue
//        xAxis.centerAxisLabelsEnabled = true
    }
    
    func formatLegend(legend: Legend) {
        legend.textColor = .red
        legend.horizontalAlignment = .right
        legend.verticalAlignment = .top
        legend.drawInside = true
        legend.yOffset = 30.0
    }
    
}

struct PemeliharaanChartView_Previews: PreviewProvider {
    static var previews: some View {
        PemeliharaanChartView(entries: DataDashPemeliharaan.dataEntriesForYear(2019, transactions: DataDashPemeliharaan.allDataDashPemeliharaan), selectedYear: .constant(2019), selectedItem: .constant(""))
    }
}

// Data Modal Dashboard Pemeliharaan
struct DataDashPemeliharaan {
    var year: Int
    var month: Double
    var quantity:  Double
    
    static func dataEntriesForYear(_ year: Int, transactions: [DataDashPemeliharaan]) -> [BarChartDataEntry] {
        let yearTransactions = transactions.filter{$0.year == year}
        return yearTransactions.map{BarChartDataEntry(x: $0.month, y: $0.quantity)}
    }
    
    static var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    static var allDataDashPemeliharaan:[DataDashPemeliharaan] {
        [
            DataDashPemeliharaan(year: 2019, month: 0, quantity: 86),
            DataDashPemeliharaan(year: 2019, month: 1, quantity: 15),
            DataDashPemeliharaan(year: 2019, month: 2, quantity: 35),
            DataDashPemeliharaan(year: 2019, month: 3, quantity: 45),
            DataDashPemeliharaan(year: 2019, month: 4, quantity: 5),
            DataDashPemeliharaan(year: 2019, month: 5, quantity: 10),
            DataDashPemeliharaan(year: 2019, month: 6, quantity: 22),
            DataDashPemeliharaan(year: 2019, month: 7, quantity: 21),
            DataDashPemeliharaan(year: 2019, month: 8, quantity: 50),
            DataDashPemeliharaan(year: 2019, month: 9, quantity: 55),
            DataDashPemeliharaan(year: 2019, month: 10, quantity: 5),
            DataDashPemeliharaan(year: 2019, month: 11, quantity: 1),
            
            DataDashPemeliharaan(year: 2020, month: 0, quantity: 33),
            DataDashPemeliharaan(year: 2020, month: 1, quantity: 5),
            DataDashPemeliharaan(year: 2020, month: 2, quantity: 3),
            DataDashPemeliharaan(year: 2020, month: 3, quantity: 14),
            DataDashPemeliharaan(year: 2020, month: 4, quantity: 52),
            DataDashPemeliharaan(year: 2020, month: 5, quantity: 13),
            DataDashPemeliharaan(year: 2020, month: 6, quantity: 32),
            DataDashPemeliharaan(year: 2020, month: 7, quantity: 17),
            DataDashPemeliharaan(year: 2020, month: 8, quantity: 45),
            DataDashPemeliharaan(year: 2020, month: 9, quantity: 58),
            DataDashPemeliharaan(year: 2020, month: 10, quantity: 4),
            DataDashPemeliharaan(year: 2020, month: 11, quantity: 8),
        ]
    }
}
