//
//  GangguanLalinModel.swift
//  JID.COM
//
//  Created by Panda on 15/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI

struct InitDataGangguan: Codable, Identifiable {
    var idx: Int
    let id_ruas: Int
    let nama_ruas: String
    let waktu_kejadian: String
    let waktu_selesai: String?
    let ket_tipe_gangguan: String
    let km: String
    let jalur: String
    let lajur: String
    let id_status: Int
    let ket_status: String
    let dampak: String
    let detail_kejadian: String
    var id: Int {idx}
}

class GangguanLalinModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceData = "source-gangguanlalin"
    var mapView: MapView!
    var timer = Timer()
    var sizeIcon: Double = 0.6
    
    
    func setUpGangguanlalinAPI(setmapView: MapView)  {
        print("run layar gangguanlalin...")
        DispatchQueue.global().async{
            RestApiController().getAPI(from: "gangguanlalin"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of data FeatureCollection gangguanlalin...")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "crash_32")!,
                                                             id: "icon_gangguanlalin")
                    
                    var symbollayer = SymbolLayer(id: "gangguanlalin")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceData
                    symbollayer.iconImage = .constant(.name("icon_gangguanlalin"))
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"ket_tipe_gangguan"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.4)
                    symbollayer.iconAllowOverlap = .constant(true)
                    
                    if setmapView.mapboxMap.style.sourceExists(withId: "source-gangguanlalin") == false {
                        try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceData)
                        try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    }
                    
                    
                    self.mapView = setmapView
                    
                    DispatchQueue.main.async {
                        do {
                            try self.mapView.mapboxMap.style.updateLayer(withId: "gangguanlalin", type: SymbolLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsEventTol[0] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Galam menjalankan proses toggle layer gangguanlalin")
                        }
                        
                    }
                    
                    self.timer.invalidate()
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 100, target: self, selector: #selector(self.setUpdateLayersGangguanlalin), userInfo: nil, repeats: true)
                    
                    
                }
            }
        }
    }
    
    @objc func setUpdateLayersGangguanlalin(){
        print("Update gangguanlalin is running...")
        DispatchQueue.global(qos: .background).async {
            RestApiController().getAPI(from: "gangguanlalin"){ (returnedData) in
                DispatchQueue.main.async {
                    if let jsonData = try? JSONEncoder().encode(returnedData) {
                        var featureCollection: FeatureCollection!
                        do{
                            featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                        }catch{
                            print("Something went wrong of data gangguanlalin realtime...")
                            return
                        }
         
                        try! self.mapView.mapboxMap.style.updateGeoJSONSource(withId: self.sourceData, geoJSON: .featureCollection(featureCollection))
                        try! self.mapView.mapboxMap.style.updateLayer(withId: "gangguanlalin", type: SymbolLayer.self){ symbollayar in
                            symbollayar.source = self.sourceData
                            symbollayar.iconImage = .constant(.name("icon_gangguanlalin"))
                        }
                    }
                }
            }
        }
    }
    
    
    func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        timer = Timer()
    }
    
    //List Data Gangguan
    func getListDataGangguan(completion: @escaping ([InitDataGangguan]) -> ())  {
        DispatchQueue.global().async {
            RestApiController().resAPIDevGet(endPoint: "gangguan_lalin/v1/getGangguan?limit=10&order=asc&offset=1", method: .get) { (results) in
                let getJSON = JSON(results ?? "Null data from API")
                DispatchQueue.main.async {
                    if getJSON["status"].boolValue {
                        do {
                            let jsonData = try JSONEncoder().encode(getJSON["data"])
                            let decodedSentences = try JSONDecoder().decode([InitDataGangguan].self, from: jsonData)
                            completion(decodedSentences)
                        } catch let myJSONError {
                            print(myJSONError)
                        }
                    }else{
                        print(getJSON["msg"].stringValue)
                    }
                }
            }
        }
    }
    
    //end class
}
