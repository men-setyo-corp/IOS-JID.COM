//
//  JalanPenghubungModel.swift
//  JID.COM
//
//  Created by Panda on 15/12/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class JalanPenghubungModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceData = "sourcejlnpenghubung"
    var mapView: MapView!
    var sizeIcon: Double = 0.9
    
    
    func setUpJlnPengubungAPI(setmapView: MapView)  {
        print("run layar Jalan penguhubng...")
        DispatchQueue.global().async{
            RestApiController().getAPI(from: "data/jalan_penghubung"){ (returnedData) in
              
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of data FeatureCollection jalan penghubung...")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    var lineLayer = LineLayer(id: "jlnpenghubung")
                    lineLayer.filter = Exp(.eq) {
                        "$type"
                        "LineString"
                    }
                    lineLayer.source =  self.sourceData
                    
                    lineLayer.lineColor = .constant(StyleColor(.gray))
                    lineLayer.lineWidth = .constant(3.0)
                    
                    try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceData)
                    try! setmapView.mapboxMap.style.addLayer(lineLayer, layerPosition: nil)
                    
                    DispatchQueue.main.async {
                        do {
                            try setmapView.mapboxMap.style.updateLayer(withId: "jlnpenghubung", type: LineLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsInfoJalanTol[2] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Galam menjalankan proses toggle layer jalan penghubung")
                        }
                    }
                    
                    
                }
            }
        }
    }
    //end class
}
