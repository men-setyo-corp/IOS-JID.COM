//
//  WaterLevelModel.swift
//  JID.COM
//
//  Created by Panda on 18/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI

struct InitDataWL: Codable, Identifiable {
    let id: Int
    let ruas_id: Int
    let nama_ruas: String
    let url_cctv: String
    let waktu_update: String
    let nama_lokasi: String
    let status_pompa: Bool
    let pompa: String
    let hujan: String
    let level: String
    let level_sensor: Int
    let kode_alat_vendor: String
}

class WaterLevelModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceDatawater = "source-waterlevel"
    var mapView: MapView!
    var sizeIcon: Double = 0.4
    
    func setUpWaterLevelAPI(setmapView: MapView)  {
        print("run layar data water_level...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "client-api/data/water_level"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data water_level")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "wls_awas")!,
                                                             id: "ic_level_awas")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "wls_normal")!,
                                                             id: "ic_level_normal")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "wls_disconnect")!,
                                                             id: "ic_diskonek")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "wls_siaga1")!,
                                                             id: "ic_level_siaga1")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "wls_siaga2")!,
                                                             id: "ic_level_siaga2")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "wls_siaga3")!,
                                                             id: "ic_level_siaga3")
                   
                    
                    var symbollayer = SymbolLayer(id: "waterlevel-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceDatawater
                    
                    let expressionIcon = Exp(.switchCase) {
                        Exp(.eq) {
                            Exp(.get) { "level" }
                                "NORMAL"
                            }
                        "ic_level_normal"
                        Exp(.eq) {
                            Exp(.get) { "level" }
                                "SIAGA 1"
                            }
                        "ic_level_siaga1"
                        Exp(.eq) {
                            Exp(.get) { "level" }
                                "SIAGA 2"
                            }
                        "ic_level_siaga2"
                        Exp(.eq) {
                            Exp(.get) { "level" }
                                "SIAGA 3"
                            }
                        "ic_level_siaga3"
                        Exp(.eq) {
                            Exp(.get) { "level" }
                                "DISCONNECT"
                            }
                        "ic_level_normal"
                        Exp(.eq) {
                            Exp(.get) { "level" }
                                "AWAS"
                            }
                        "ic_level_awas"
                        "ic_level_normal"
                    }
                    
                    symbollayer.iconImage = .expression(expressionIcon)
                    
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"level_sensor"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.6)
                    
                    if setmapView.mapboxMap.style.sourceExists(withId: "source-waterlevel") == false {
                        try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceDatawater)
                        try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    }
                    
                }
            }
        }
    }
    
    
    func getWaterLevelSensor(idruas: Int, completion: @escaping ([InitDataWL]) -> ())  {
        var setIdruas = ""
        if idruas == 0 {
            setIdruas = ""
        }else{
            setIdruas = "?id_ruas=\(String(idruas))"
        }
        DispatchQueue.global().async {
            RestApiController().resAPIGet(endPoint: "water_level_sensor/v1/getWaterLevelSensor\(setIdruas)", method: .get) { (results) in
                let getJSON = JSON(results ?? "Null data from API")
                DispatchQueue.main.async {
                    if getJSON["status"].boolValue {
                        do {
                            let jsonData = try JSONEncoder().encode(getJSON["data"])
                            let decodedSentences = try JSONDecoder().decode([InitDataWL].self, from: jsonData)
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
