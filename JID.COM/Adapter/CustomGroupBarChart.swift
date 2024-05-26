//
//  GroupBarChartPemeliharaan.swift
//  JID.COM
//
//  Created by Panda on 26/09/23.
//

import DGCharts
import SwiftUI

struct CustomGroupedBarChart: UIViewRepresentable {
    @Binding var selectedItem: TransactionCustom
    var entriesSelesai: [BarChartDataEntry]
    var entriesProses: [BarChartDataEntry]
    var entriesRencana: [BarChartDataEntry]
    let CustomgroupedBarChart = BarChartView()
    let barWidth = 0.35
    let barSpace = 0.05
    let groupSpace = 0.2
    let startX:Double = 0
    func makeUIView(context: Context) -> BarChartView {
        CustomgroupedBarChart.delegate = context.coordinator
        return CustomgroupedBarChart
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
        barChart.xAxis.axisMinimum = startX
//        barChart.xAxis.axisMaximum = 15
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.granularity = 1
//        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:TransactionCustom.monthArray)
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
    
    func configureChart(_ barChart: BarChartView) {
        barChart.noDataText = "No Data"
        barChart.rightAxis.enabled = false
        barChart.fitBars = true
        barChart.setScaleEnabled(false)
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
        let parent: CustomGroupedBarChart
        init(parent: CustomGroupedBarChart) {
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

struct CustomGroupedBarChart_Previews: PreviewProvider {
    static var previews: some View {
        CustomGroupedBarChart(selectedItem: .constant(TransactionCustom.selectedItem),
                        entriesSelesai: TransactionCustom.transactionCustomsForYear(2019, transactionCustoms: TransactionCustom.allTransactionCustoms, kategori: .Selesai),
                        entriesProses: TransactionCustom.transactionCustomsForYear(2019, transactionCustoms: TransactionCustom.allTransactionCustoms, kategori: .Proses),
                        entriesRencana: TransactionCustom.transactionCustomsForYear(2019, transactionCustoms: TransactionCustom.allTransactionCustoms, kategori: .Rencana))
    }
}

//Data TransactionCustom
struct TransactionCustom {
    enum Kategori: String {
        case Selesai, Proses, Rencana, none
    }
    
    var year: Int
    var month: Double
    var quantity: Double
    var kategori: Kategori

    static var selectedItem = TransactionCustom(year: 2019, month: -1, quantity: -1, kategori: .none)
    static func initialItem(year: Int) -> TransactionCustom {
        TransactionCustom(year: year, month: -1, quantity: -1, kategori: .none)
    }
    static var monthArray = ["Jan","","","Feb","","", "Mar", "", "", "Apr", "", "","Mei","","", "Jun", "", "", "Jul", "", "", "Agu", "", "", "Sep", "", "", "Okt", "", "", "Nov", "", "", "Des"]
    static func transactionCustomsForYear(_ year: Int, transactionCustoms: [TransactionCustom], kategori:Kategori) -> [BarChartDataEntry] {
        let yearData = transactionCustoms.filter{$0.year == year && $0.kategori == kategori}
        return yearData.map{BarChartDataEntry(x: $0.month, y: $0.quantity )}
    }
    
    static var allTransactionCustoms:[TransactionCustom] {
        [
            TransactionCustom(year: 2019, month: 5, quantity: 76, kategori: .Selesai),
            TransactionCustom(year: 2019, month: 6, quantity: 15, kategori: .Selesai),
            TransactionCustom(year: 2019, month: 7, quantity: 50, kategori: .Selesai),
            TransactionCustom(year: 2019, month: 8, quantity: 62, kategori: .Selesai),
            TransactionCustom(year: 2019, month: 9, quantity: 20, kategori: .Selesai),
            
            TransactionCustom(year: 2019, month: 5, quantity: 1, kategori: .Proses),
            TransactionCustom(year: 2019, month: 6, quantity: 45, kategori: .Proses),
            TransactionCustom(year: 2019, month: 7, quantity: 20, kategori: .Proses),
            TransactionCustom(year: 2019, month: 8, quantity: 32, kategori: .Proses),
            TransactionCustom(year: 2019, month: 9, quantity: 30, kategori: .Proses),
            
            TransactionCustom(year: 2019, month: 5, quantity: 5, kategori: .Rencana),
            TransactionCustom(year: 2019, month: 6, quantity: 65, kategori: .Rencana),
            TransactionCustom(year: 2019, month: 7, quantity: 2, kategori: .Rencana),
            TransactionCustom(year: 2019, month: 8, quantity: 33, kategori: .Rencana),
            TransactionCustom(year: 2019, month: 9, quantity: 42, kategori: .Rencana)
        ]
    }

}
