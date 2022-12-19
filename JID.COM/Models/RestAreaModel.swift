//
//  RestAreaModel.swift
//  JID.COM
//
//  Created by Panda on 16/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class RestAreamodel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceDataGerbang = "source-restarea"
    var mapView: MapView!
    var sizeIcon: Double = 0.8
    
    func setUpRestAreaAPI(setmapView: MapView)  {
        print("run layar data rest_area...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "data/rest_area"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data rest_area")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "park_24")!,
                                                             id: "ico_normal")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "busy_park_24")!,
                                                             id: "ico_penuh")
                   
                    
                    var symbollayer = SymbolLayer(id: "restarea-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceDataGerbang
                    
                    let expressionIcon = Exp(.switchCase) {
                        Exp(.eq) {
                            Exp(.get) { "poi" }
                                "restareanormal"
                            }
                        "ico_normal"
                        Exp(.eq) {
                            Exp(.get) { "poi" }
                                "restareapenuh"
                            }
                        "ico_penuh"
                        "ico_normal"
                    }
                    
                    symbollayer.iconImage = .expression(expressionIcon)
                    
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"nama_rest_area"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.6)
                    
                    if setmapView.mapboxMap.style.sourceExists(withId: "source-restarea")  == false {
                        try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceDataGerbang)
                        try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    }
                    
                    
                }
            }
        }
    }
    //end class
}
