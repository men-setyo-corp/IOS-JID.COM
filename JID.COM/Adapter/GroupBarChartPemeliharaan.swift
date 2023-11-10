//
//  GroupBarChartPemeliharaan.swift
//  JID.COM
//
//  Created by Panda on 26/09/23.
//

import DGCharts
import SwiftUI

struct GroupedBarChart: UIViewRepresentable {
    @Binding var selectedItem: Transaction
    var entriesSelesai: [BarChartDataEntry]
    var entriesProses: [BarChartDataEntry]
    var entriesRencana: [BarChartDataEntry]
    let groupedBarChart = BarChartView()
    let barWidth = 0.35
    let barSpace = 0.05
    let groupSpace = 0.2
    let startX:Double = 0
    func makeUIView(context: Context) -> BarChartView {
        groupedBarChart.delegate = context.coordinator
        return groupedBarChart
    }

    func updateUIView(_ uiView: BarChartView, context: Context) {
        setChartDataAndXaxis(uiView)
        configureChart(uiView)
        formatLeftAxis(leftAxis: uiView.leftAxis)
        formatLegend(legend: uiView.legend)
        uiView.notifyDataSetChanged()
    }
    
    func setChartDataAndXaxis(_ barChart: BarChartView) {
        barChart.noDataText = "No Data"
        barChart.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
        
        let dataSetSelesai = BarChartDataSet(entries: entriesSelesai)
        let dataSetProses = BarChartDataSet(entries: entriesProses)
        let dataSetRencana = BarChartDataSet(entries: entriesRencana)
        
        let dataSets:[BarChartDataSet] = [dataSetSelesai,dataSetProses, dataSetRencana]
        let chartData = BarChartData(dataSets: dataSets)
        barChart.data = chartData
        
        formatDataSet(dataSet: dataSetSelesai, label: "Selesai", color: .systemGreen)
        formatDataSet(dataSet: dataSetProses, label: "Proses", color: .systemBlue)
        formatDataSet(dataSet: dataSetRencana, label: "Dalam Rencana", color: .systemOrange)
        
        
        chartData.groupBars(fromX: 0, groupSpace: 0.35, barSpace: 0.03)
        barChart.xAxis.centerAxisLabelsEnabled = true
        barChart.xAxis.axisMinimum = 0
        barChart.xAxis.axisMaximum = 15
        barChart.xAxis.labelPosition = .bottom
//        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:Transaction.monthArray)
    }
    
    func formatDataSet(dataSet: BarChartDataSet, label: String, color: UIColor) {
        dataSet.label = label
        dataSet.highlightAlpha = 1
        dataSet.colors = [color]
        let format = NumberFormatter()
        dataSet.valueColors = [color]
        format.numberStyle = .none
        dataSet.valueFormatter = DefaultValueFormatter(formatter: format)
    }

    func formatXAxis(xAxis: XAxis) {
        xAxis.axisMinimum = 0
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = IndexAxisValueFormatter(values:Transaction.monthArray)
        xAxis.labelTextColor =  .systemGreen
        xAxis.granularity = 1
        xAxis.centerAxisLabelsEnabled = true
    }
    
    func configureChart(_ barChart: BarChartView) {
        barChart.noDataText = "No Data"
        barChart.rightAxis.enabled = false
        barChart.fitBars = true
        barChart.setScaleEnabled(false)
//        if barChart.scaleX == 1.0 {
//            barChart.zoom(scaleX: 1.5, scaleY: 1, x: 0, y: 0)
//        }
//        if selectedItem.month == -1 {
//            barChart.animate(xAxisDuration: 0, yAxisDuration: 0.5, easingOption: .linear)
//            barChart.highlightValue(nil, callDelegate: false)
//        }
    }

    func formatLeftAxis(leftAxis:YAxis) {
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.numberStyle = .none
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelTextColor =  .red
        leftAxis.axisMinimum = 0
    }

    func formatLegend(legend: Legend) {
        legend.textColor = UIColor.red
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .top
        legend.drawInside = true
        legend.yOffset = 0.0
    }

    class Coordinator: NSObject, ChartViewDelegate {
        let parent: GroupedBarChart
        init(parent: GroupedBarChart) {
            self.parent = parent
        }
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            parent.selectedItem.month = entry.x
            parent.selectedItem.quantity = entry.y
            if entry.y < 0 {
                parent.selectedItem.kategori = .Selesai
            } else {
                parent.selectedItem.kategori = .Proses
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}

struct GroupedBarChart_Previews: PreviewProvider {
    static var previews: some View {
        GroupedBarChart(selectedItem: .constant(Transaction.selectedItem),
                        entriesSelesai: Transaction.transactionsForYear(2019, transactions: Transaction.allTransactions, kategori: .Selesai),
                        entriesProses: Transaction.transactionsForYear(2019, transactions: Transaction.allTransactions, kategori: .Proses),
                        entriesRencana: Transaction.transactionsForYear(2019, transactions: Transaction.allTransactions, kategori: .Rencana))
    }
}

//Data Transaction
struct Transaction {
    enum Kategori: String {
        case Selesai, Proses, Rencana, none
    }
    
    var year: Int
    var month: Double
    var quantity: Double
    var kategori: Kategori

    static var selectedItem = Transaction(year: 2019, month: -1, quantity: -1, kategori: .none)
    static func initialItem(year: Int) -> Transaction {
        Transaction(year: year, month: -1, quantity: -1, kategori: .none)
    }
    static var monthArray = ["Jan","Feb","Mar","Apr","Mei","Jun", "Jul", "Agu", "Sep", "Okt", "Nov", "Des"]
    static func transactionsForYear(_ year: Int, transactions: [Transaction], kategori:Kategori) -> [BarChartDataEntry] {
        let yearData = transactions.filter{$0.year == year && $0.kategori == kategori}
        return yearData.map{BarChartDataEntry(x: $0.month, y: $0.quantity )}
    }

//    static func lineChartDataForYear(_ year: Int, transactions: [Transaction], kategori:Kategori = .Selesai) -> [ChartDataEntry] {
//        let yearData = transactions.filter{$0.year == year && $0.kategori == kategori}
//        return yearData.map{BarChartDataEntry(x: $0.month, y: $0.quantity)}
//    }

    static var allTransactions:[Transaction] {
        [
            Transaction(year: 2019, month: 0, quantity: 86, kategori: .Selesai),
            Transaction(year: 2019, month: 1, quantity: 15, kategori: .Selesai),
            Transaction(year: 2019, month: 2, quantity: 50, kategori: .Selesai),
            Transaction(year: 2019, month: 3, quantity: 62, kategori: .Selesai),
            Transaction(year: 2019, month: 4, quantity: 20, kategori: .Selesai),
            
            Transaction(year: 2019, month: 0, quantity: 1, kategori: .Proses),
            Transaction(year: 2019, month: 1, quantity: 45, kategori: .Proses),
            Transaction(year: 2019, month: 2, quantity: 20, kategori: .Proses),
            Transaction(year: 2019, month: 3, quantity: 32, kategori: .Proses),
            Transaction(year: 2019, month: 4, quantity: 30, kategori: .Proses),
            
            Transaction(year: 2019, month: 0, quantity: 5, kategori: .Rencana),
            Transaction(year: 2019, month: 1, quantity: 65, kategori: .Rencana),
            Transaction(year: 2019, month: 2, quantity: 2, kategori: .Rencana),
            Transaction(year: 2019, month: 3, quantity: 33, kategori: .Rencana),
            Transaction(year: 2019, month: 4, quantity: 42, kategori: .Rencana)
        ]
    }

}
