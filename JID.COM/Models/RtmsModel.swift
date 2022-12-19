//
//  RtmsModel.swift
//  JID.COM
//
//  Created by Panda on 17/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class RtmsModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceDataRtms = "source-rtms"
    var mapView: MapView!
    var sizeIcon: Double = 0.8
    
    func setUpRtmsAPI(setmapView: MapView)  {
        print("run layar data rtms...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "data/rtms"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data rtms")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "rtms_b_24")!,
                                                             id: "rtmson")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "rtms_r_24")!,
                                                             id: "rtmsoff")
                   
                    
                    var symbollayer = SymbolLayer(id: "rtms-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceDataRtms
                    
                    let expressionIcon = Exp(.switchCase) {
                        Exp(.eq) {
                            Exp(.get) { "img" }
                                "rtmson"
                            }
                        "rtmson"
                        Exp(.eq) {
                            Exp(.get) { "img" }
                                "rtmsoff"
                            }
                        "rtmsoff"
                        "rtmson"
                    }
                    
                    symbollayer.iconImage = .expression(expressionIcon)
                    
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"nama_lokasi"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.6)
                    
                    try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceDataRtms)
                    try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    
                    DispatchQueue.main.async {
                        do {
                            try setmapView.mapboxMap.style.updateLayer(withId: "rtms-symbol", type: SymbolLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsSisinfokom[2] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Gagal menjalankan proses toggle layer rtms")
                        }
                       
                    }
                    
                }
            }
        }
    }
    //end class
}
