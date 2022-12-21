//
//  Rtms2Model.swift
//  JID.COM
//
//  Created by Panda on 17/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class Rtms2Model: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceDataRtms = "source-rtms2"
    var mapView: MapView!
    var sizeIcon: Double = 0.8
    
    func setUpRtms2API(setmapView: MapView)  {
        print("run layar data rtms 2...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "data/rtms2"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data rtms2")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "rtms2_g_24")!,
                                                             id: "ic_rtms2on")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "rtms2_p_24")!,
                                                             id: "ic_rtms2off")
                   
                    
                    var symbollayer = SymbolLayer(id: "rtms2-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceDataRtms
                    
                    let expressionIcon = Exp(.switchCase) {
                        Exp(.eq) {
                            Exp(.get) { "img" }
                                "rtms2on"
                            }
                        "ic_rtms2on"
                        Exp(.eq) {
                            Exp(.get) { "img" }
                                "rtms2off"
                            }
                        "ic_rtms2off"
                        "ic_rtms2on"
                    }
                    
                    symbollayer.iconImage = .expression(expressionIcon)
                    
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"nama_lokasi"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.6)
                    
                    if setmapView.mapboxMap.style.sourceExists(withId: self.sourceDataRtms) == false {
                        try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceDataRtms)
                        try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    }
                   
                    
                    DispatchQueue.main.async {
                        do {
                            try setmapView.mapboxMap.style.updateLayer(withId: "rtms2-symbol", type: SymbolLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsSisinfokom[3] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Gagal menjalankan proses toggle layer rtms2")
                        }
                        
                    }
                    
                }
            }
        }
    }
    //end class
}

