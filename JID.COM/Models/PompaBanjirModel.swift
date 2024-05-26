//
//  PompaBanjirModel.swift
//  JID.COM
//
//  Created by Panda on 18/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class PompaBanjirModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceDatawater = "source-pompa"
    var mapView: MapView!
    var sizeIcon: Double = 0.5
    
    func setUpPompaBanjirAPI(setmapView: MapView)  {
        print("run layar data pompa...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "client-api/data/pompa"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data pompa")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "pumpa")!,
                                                             id: "ic_pumpa")
                   
                    
                    var symbollayer = SymbolLayer(id: "pompa-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceDatawater
                    
                    symbollayer.iconImage = .constant(.name("ic_pumpa"))
                    
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"no_urut_pompa"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.6)
                    
                    if setmapView.mapboxMap.style.sourceExists(withId: "source-pompa") == false {
                        try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceDatawater)
                        try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    }
                    
                }
            }
        }
    }
    //end class
}
