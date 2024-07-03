//
//  BatasKmModel.swift
//  JID.COM
//
//  Created by Panda on 15/12/22.
//


import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class BatasKmModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceData = "source-bataskm"
    var mapView: MapView!
    var sizeIcon: Double = 0.3
    
    
    func setUpBatasKmAPI(setmapView: MapView)  {
        print("run layar bataskm...")
        DispatchQueue.global(qos: .background).async {
            RestApiController().getAPI(from: "client-api/data/bataskm/"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data cctv")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "kmbatas")!,
                                                             id: "ic_bataskm")
                   
                    
                    var symbollayer = SymbolLayer(id: "bataskm-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceData
                    
                    symbollayer.iconImage = .constant(.name("ic_bataskm"))
                    symbollayer.iconSize = .constant(0.5)
                    symbollayer.textField = .expression(Exp(.get){"label"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.6)
                    
                    if setmapView.mapboxMap.style.sourceExists(withId: self.sourceData) == false {
                        try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceData)
                        try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    }
                    
                    
                    self.mapView = setmapView
                    
                    DispatchQueue.main.async {
                        do {
                            try self.mapView.mapboxMap.style.updateLayer(withId: "bataskm-symbol", type: SymbolLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsInfoJalanTol[1] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Gagal menjalankan proses toggle layer batas km")
                        }
                    }
                    
                }
            }
        }
    }
    //end class
}
