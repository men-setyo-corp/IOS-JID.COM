//
//  GpsKendaraanModel.swift
//  JID.COM
//
//  Created by Panda on 18/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class GpsKendaraanModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceDatawater = "source-gpskendaraan"
    var mapView: MapView!
    var sizeIcon: Double = 0.6
    
    func setUpGPSKendaraanAPI(setmapView: MapView)  {
        print("run layar data gps_kendaraan...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "client-api/data/gps_kendaraan"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data gps_kendaraan")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    //ambulan
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "ambulance")!,
                                                             id: "ic_ambulance")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "vehicle_ambulance_idle")!,
                                                             id: "ic_ambulance_stop")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "vehicle_ambulance_move")!,
                                                             id: "ic_ambulance_run")
                    //derek
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "derek")!,
                                                             id: "ic_derek")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "vehicle_derek_idle")!,
                                                             id: "ic_derek_stop")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "vehicle_derek_move")!,
                                                             id: "ic_derek_run")
                    //kamtib
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "kamtib")!,
                                                             id: "ic_kamtib")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "vehicle_kamtib_idle")!,
                                                             id: "ic_kamtib_stop")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "vehicle_kamtib_move")!,
                                                             id: "ic_kamtib_run")
                    //patroli
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "patroli")!,
                                                             id: "ic_patroli")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "vehicle_patroli_idle")!,
                                                             id: "ic_patroli_stop")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "vehicle_patroli_move")!,
                                                             id: "ic_patroli_runn")
                    //support
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "support")!,
                                                             id: "ic_support")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "vehicle_support_idle")!,
                                                             id: "ic_support_stop")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "vehicle_patroli_move")!,
                                                             id: "ic_support_run")
                   
                    
                    var symbollayer = SymbolLayer(id: "gpskendaraan-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceDatawater
                    
                    let expressionIcon = Exp(.switchCase) {
                        Exp(.eq) {
                            Exp(.get) { "poi" }
                            "ambulance_30"
                        }
                        "ic_ambulance"
                        Exp(.eq) {
                            Exp(.get) { "poi" }
                            "derek_30"
                        }
                        "ic_derek"
                        Exp(.eq) {
                            Exp(.get) { "poi" }
                            "kamtib_30"
                        }
                        "ic_kamtib"
                        Exp(.eq) {
                            Exp(.get) { "poi" }
                            "patroli_30"
                        }
                        "ic_patroli"
                        Exp(.eq) {
                            Exp(.get) { "poi" }
                            "support_30"
                        }
                        "ic_support"
                        "ic_ambulance"
                    }
                    
                    symbollayer.iconImage = .expression(expressionIcon)
                    
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"level_sensor"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.6)
                    
                    if setmapView.mapboxMap.style.sourceExists(withId: "source-gpskendaraan") == false {
                        try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceDatawater)
                        try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    }
                    
                }
            }
        }
    }
    //end class
}
