//
//  RadarModel.swift
//  JID.COM
//
//  Created by Panda on 17/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class RadarModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceData = "source-radar"
    var mapView: MapView!
    var sizeIcon: Double = 0.4
    
    func setUpRadarAPI(setmapView: MapView)  {
        print("run layar data radar ...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "client-api/data/radar"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data radar")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "trafik_radar")!,
                                                             id: "radaron")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "radar_off")!,
                                                             id: "radaroff")
                   
                    
                    var symbollayer = SymbolLayer(id: "radar-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceData
                    let expressionIcon = Exp(.switchCase) {
                        Exp(.eq) {
                            Exp(.get) { "icon" }
                                "radaron"
                            }
                        "radaron"
                        Exp(.eq) {
                            Exp(.get) { "icon" }
                                "radaroff"
                            }
                        "radaroff"
                        "radaron"
                    }
                    
                    symbollayer.iconImage = .expression(expressionIcon)
//                    symbollayer.iconImage = .constant(.name("ic_radar"))
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"nama_lokasi"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.6)
                    
                    if setmapView.mapboxMap.style.sourceExists(withId: self.sourceData) == false {
                        try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceData)
                        try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    }
                    
                    
                    DispatchQueue.main.async {
                        do {
                            try setmapView.mapboxMap.style.updateLayer(withId: "radar-symbol", type: SymbolLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsSisinfokom[4] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Gagal menjalankan proses toggle layer radar")
                        }
                        
                    }
                    
                }
            }
        }
    }
    //end class
}
