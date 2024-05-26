//
//  MidasModel.swift
//  JID.COM
//
//  Created by Panda on 22/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class MidasModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceData = "source-midas"
    var mapView: MapView!
    var sizeIcon: Double = 0.01
    var sizeIcon1: Double = 0.1
    var timer = Timer()
    
    func setUpMidasAPI(setmapView: MapView)  {
        print("run layar data midas...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "client-api/data/midas"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data midas")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "midas")!,
                                                             id: "ic_midas")
                   
                    
                    var symbollayer = SymbolLayer(id: "midas-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceData
                    
                    symbollayer.iconImage = .constant(.name("ic_midas"))
                    
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    
                    try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceData)
                    try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    
                }
            }
        }
    }
    
    
    
    func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        timer = Timer()
    }
    //end class
}
