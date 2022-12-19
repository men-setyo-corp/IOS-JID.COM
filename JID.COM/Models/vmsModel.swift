//
//  vmsModel.swift
//  JID.COM
//
//  Created by Panda on 13/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class vmsModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceDataVms = "source-vms"
    var mapView: MapView!
    var sizeIcon: Double = 0.9
    
    
    func setUpVMSAPI(setmapView: MapView)  {
        print("run layar vms...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "showvms"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of featurecollection data cctv")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "vms_on")!,
                                                             id: "vms_on")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "vms_off")!,
                                                             id: "vms_off")
                   
                    
                    var symbollayer = SymbolLayer(id: "vms-symbol")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceDataVms
                    
                    let expressionIcon = Exp(.switchCase) {
                        Exp(.eq) {
                            Exp(.get) { "icon" }
                                "vms_on"
                            }
                        "vms_on"
                        Exp(.eq) {
                            Exp(.get) { "icon" }
                                "vms_off"
                            }
                        "vms_off"
                        "vms_on"
                    }
                    
                    symbollayer.iconImage = .expression(expressionIcon)
                    
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"nama_lokasi"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.6)
                    
                    try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceDataVms)
                    try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    
                    self.mapView = setmapView
                    
                    DispatchQueue.main.async {
                        do {
                            try self.mapView.mapboxMap.style.updateLayer(withId: "vms-symbol", type: SymbolLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsSisinfokom[0] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Gagal menjalankan proses toggle layer pemeliharaan")
                        }
                        
                    }
                    
                }
            }
        }
    }
    //end class
}
