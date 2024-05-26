//
//  GrafikPerjalur.swift
//  JID.COM
//
//  Created by Panda on 05/10/23.
//

import Foundation
import DGCharts
import SwiftUI
import SwiftyJSON

struct GrafikPerjalur: UIViewRepresentable {
    var entries : [PieChartDataEntry]
    let pieChart = PieChartView()
    func makeUIView(context: Context) -> PieChartView {
        pieChart.delegate = context.coordinator
        return pieChart
    }
    
    func updateUIView(_ uiView: PieChartView, context: Context) {
        let dataSet = PieChartDataSet(entries: entries, label: "")
//        dataSet.colors = ChartColorTemplates.liberty()
        dataSet.colors = [.systemBlue, .systemGreen]
        let pieChartData = PieChartData(dataSet: dataSet)
        uiView.data = pieChartData
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 0
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        pieChartData.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        //condig
        configureChart(uiView)
        formatCenter(uiView)
        formatLegend(uiView.legend)
        formatDataSet(dataSet)
        uiView.notifyDataSetChanged()
    }
    
    class Coordinator: NSObject, ChartViewDelegate {
        var parent: GrafikPerjalur
        init(parent: GrafikPerjalur) {
            self.parent = parent
        }
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            let labelText = entry.value(forKey: "label")! as! String
            let num = Int(entry.value(forKey: "data")! as! Double)
            parent.pieChart.centerText = ("""
            \(labelText)
            \(num)
            """)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func configureChart(_ pieChart: PieChartView) {
        pieChart.rotationEnabled = true
        pieChart.animate(xAxisDuration: 0.5, easingOption: .easeInOutCirc)
        pieChart.drawEntryLabelsEnabled = false
        pieChart.highlightValue(x: -1, dataSetIndex: 0, callDelegate: false)
    }
    
    func formatCenter(_ pieChart: PieChartView) {
        pieChart.holeColor = UIColor.systemBackground
        pieChart.centerText = "Grafik Per-Jalur"
        pieChart.centerTextRadiusPercent = 0.95
    }
    
    func formatLegend(_ legend: Legend) {
        legend.horizontalAlignment = .center
        legend.enabled = true
    }
    
    func formatDataSet(_ dataSet: ChartDataSet) {
        dataSet.drawValuesEnabled = true
    }
    
}

struct PGrafikPerjalur_Previews : PreviewProvider {
    static var previews: some View {
        GrafikPerjalur(entries: Jalur.entriesForJalur(Jalur.allJalur, category: .perjalur))
    }
}
   

struct Jalur {
    enum Category: String {
        case perjalur, perlajur
    }
    var category: Category
    var value:Double
    var label:String
    var persen:Int

    static func entriesForJalur(_ jalurs: [Jalur], category: Category) -> [PieChartDataEntry] {
        let requestedEntries =  jalurs.filter{$0.category == category}
        return requestedEntries.map{PieChartDataEntry(value: $0.value, label: $0.label, data: $0.persen)}
    }
    
    static var setDataDashPerjalur: [Jalur] = []
    static var DataResCall: JSON = []
    
    static var allJalur: [Jalur] {
        guard let path = Bundle.main.path(forResource: "perjalur", ofType: "json")
        else {
            print("File perjalur tidak ditemukan")
            return setDataDashPerjalur
        }
        let filePath = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: filePath)
        let getJSON = JSON(data ?? "Null data from API")

        if getJSON["status"].boolValue {
            let result = getJSON["data"]
            var setJltA: Int = 0
            var setJltB: Int = 0
            var perSenA: Double = 0
            var perSenB: Double = 0
            for (_, value) in result {
                if value["_id"]["jalur"] == "A" {
                    setJltA = setJltA + value["jalurA"].intValue
                }
                if value["_id"]["jalur"] == "B" {
                    setJltB = setJltB + value["jalurB"].intValue
                }
            }
            let setTotVal: Int = setJltA + setJltB

            let bagiA:Double = Double(setJltA)/Double(setTotVal) * 100
            let bagiB:Double = Double(setJltB)/Double(setTotVal) * 100
            perSenA = bagiA
            perSenB = bagiB

            setDataDashPerjalur.append(
                .init(category: .perjalur, value: perSenA, label: "Jalur A", persen: setJltA)
            )
            setDataDashPerjalur.append(
                .init(category: .perjalur, value: perSenB, label: "Jalur B", persen: setJltB)
            )
        }
        
        return setDataDashPerjalur
    }

}

class GetDataApi: ObservableObject {
    @Published var setJalurA: Int = 0
    @Published var setJalurB: Int = 0
    @Published var PerJalurA: Double = 0.0
    @Published var PerJalurB: Double = 0.0
    
    init(){
        GetDataApiCall()
    }
    
    func GetDataApiCall() {
        getData() { res in
            DispatchQueue.main.async {
                for (_, value) in res {
                    if value["_id"]["jalur"] == "A" {
                        self.setJalurA = self.setJalurA + value["jalurA"].intValue
                    }
                    if value["_id"]["jalur"] == "B" {
                        self.setJalurB = self.setJalurB + value["jalurB"].intValue
                    }
                }
            
                let setTotVal: Int = self.setJalurA + self.setJalurB
                let bagiA:Double = Double(self.setJalurA)/Double(setTotVal) * 100
                let bagiB:Double = Double(self.setJalurB)/Double(setTotVal) * 100
                
                self.PerJalurA = bagiA
                self.PerJalurB = bagiB
                
                print("Jalur A awal: \(self.setJalurA)")
            }
        }
    }
    
    func getData(completion: @escaping (JSON) -> (Void)){
        RestApiController().resAPIDevGet(endPoint: "dashboard_pemeliharaan/v1/getDataJalur?ruas=4&waktu=bulan&dari=2023-01&sampai=2023-05", method: .get){ results in
            let getJSON = JSON(results ?? "Null data from API")
            let status = getJSON["status"].boolValue
            if status {
                DispatchQueue.main.async {
                    completion(getJSON["data"])
                }
            }else{
                print(getJSON["msg"])
            }
        }
    }
}
