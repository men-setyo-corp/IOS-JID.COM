//
//  SpeedModel.swift
//  JID.COM
//
//  Created by Panda on 17/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class SpeedModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceData = "source-speed"
    var mapView: MapView!
    var sizeIcon: Double = 0.8
    
    func setUpSpeedAPI(setmapView: MapView)  {
        print("run layar data speed...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "client-api/data/speed"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data speed")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "speed_b_24")!,
                                                             id: "ic_on")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "speed_r_24")!,
                                                             id: "ic_off")
                   
                    var symbollayer = SymbolLayer(id: "speed-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceData
                    
                    let expressionIcon = Exp(.switchCase) {
                        Exp(.eq) {
                            Exp(.get) { "ico" }
                                "on"
                            }
                        "ic_on"
                        Exp(.eq) {
                            Exp(.get) { "ico" }
                                "off"
                            }
                        "ic_off"
                        "ic_on"
                    }
                    
                    symbollayer.iconImage = .expression(expressionIcon)
                    
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
                            try setmapView.mapboxMap.style.updateLayer(withId: "speed-symbol", type: SymbolLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsSisinfokom[5] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Gagal menjalankan proses toggle layer speed")
                        }
                    }
                    
                }
            }
        }
    }
    //end class
}
