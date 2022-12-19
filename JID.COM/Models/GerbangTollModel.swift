//
//  GerbangTollModel.swift
//  JID.COM
//
//  Created by Panda on 15/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class GerbangTollModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceDataGerbang = "source-gerbangtoll"
    var mapView: MapView!
    var sizeIcon: Double = 0.5
    
    func setUpGerbagToillPI(setmapView: MapView)  {
        print("run layar gerbangtoll...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "data/gerbangtol"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data gerbangtol")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "gate_b_32")!,
                                                             id: "G_on")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "gate_r_32")!,
                                                             id: "G_off")
                   
                    
                    var symbollayer = SymbolLayer(id: "gerbangtoll-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceDataGerbang
                    
                    let expressionIcon = Exp(.switchCase) {
                        Exp(.eq) {
                            Exp(.get) { "poi" }
                                "rampimgon"
                            }
                        "G_on"
                        Exp(.eq) {
                            Exp(.get) { "poi" }
                                "rampimgoff"
                            }
                        "G_off"
                        "G_on"
                    }
                    
                    symbollayer.iconImage = .expression(expressionIcon)
                    
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"nama_gerbang"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.6)
                    
                    try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceDataGerbang)
                    try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    
                    DispatchQueue.main.async {
                        do {
                            try setmapView.mapboxMap.style.updateLayer(withId: "gerbangtoll-symbol", type: SymbolLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsInfoJalanTol[3] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Gagal menjalankan proses toggle layer gerbang toll")
                        }
                        
                    }
                    
                }
            }
        }
    }
    //end class
}
