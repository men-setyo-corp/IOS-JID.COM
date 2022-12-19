//
//  WimModel.swift
//  JID.COM
//
//  Created by Panda on 18/12/22.
//
import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class WimModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceDatawater = "source-wim"
    var mapView: MapView!
    var sizeIcon: Double = 0.5
    
    func setUpWimAPI(setmapView: MapView)  {
        print("run layar data wim...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "data/wim"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data wim")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "wim")!,
                                                             id: "ic_wim")
                   
                    
                    var symbollayer = SymbolLayer(id: "wim-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceDatawater
                    
                    symbollayer.iconImage = .constant(.name("ic_wim"))
                    
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"id_wim"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.6)
                    
                    if setmapView.mapboxMap.style.sourceExists(withId: "source-wim") == false {
                        try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceDatawater)
                        try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    }
                    
                }
            }
        }
    }
    //end class
}
