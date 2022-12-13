//
//  LalinModel.swift
//  JID.COM
//
//  Created by Macbook on 22/08/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class LalinModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceIdLalin = "source-lalin"
    let layaridlalin = "layar-id-lalin"
    var mapViewlalin: MapView!
    var timer = Timer()
    @State var shwHideLalin: Bool = false;
    
    func JSONLalin(from fileName: String) throws -> FeatureCollection? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            preconditionFailure("File '\(fileName)' not found.")
        }

        let filePath = URL(fileURLWithPath: path)
        var featureCollection: FeatureCollection?
        do {
            let data = try Data(contentsOf: filePath)
            featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: data)
        } catch {
            print("Error parsing data: \(error)")
        }
        return featureCollection
    }
    
    func setUpLalinAPI(setmapView: MapView)  {
        mapViewlalin = setmapView
        guard let featureCollection = try? JSONLalin(from: "lalin") else { return }
        let geoJSONDataSourceIdentifier = sourceIdLalin
        
        geoJSONSource.data = .featureCollection(featureCollection)
         
        var lineLayer = LineLayer(id: layaridlalin)
        lineLayer.filter = Exp(.eq) {
            "$type"
            "LineString"
        }
        lineLayer.source = geoJSONDataSourceIdentifier
        let colorExpression = Exp(.match)
        {
            Exp(.get) { "color" }
            "#ffcc00"
            UIColor(hexString: "#FFCC00")
            "#ff0000"
            UIColor(hexString: "#FF0000")
            "#bb0000"
            UIColor(hexString: "#BB0000")
            "#440000"
            UIColor(hexString: "#440000")
            "#00ff00"
            UIColor(hexString: "#00FF00")
            UIColor.black
        }
        
        lineLayer.lineColor = .expression(colorExpression)
        lineLayer.lineWidth = .constant(2.0)
        
        lineLayer.lineCap = .constant(.round)
        lineLayer.lineJoin = .constant(.round)
         
        // Add the source and style layer to the map style.
        try! mapViewlalin.mapboxMap.style.addSource(geoJSONSource, id: geoJSONDataSourceIdentifier)
        try! mapViewlalin.mapboxMap.style.addLayer(lineLayer, layerPosition: nil)
        
        DispatchQueue.main.async {
            do {
                try self.mapViewlalin.mapboxMap.style.updateLayer(withId: self.layaridlalin, type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[0] == "yes" ? .visible : .none)
                }
            } catch {
                print("Galam menjalankan proses toggle layer cctv")
            }
            CctvMapModel().setUpCctvAPI(setmapView: self.mapViewlalin)
        }
        
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.setUpdateLayers), userInfo: nil, repeats: true)
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.layarHideShow), userInfo: nil, repeats: true)
        
    }
    
    @objc func setUpdateLayers(){
        print("Update Lalin is running...")
        print(mapViewlalin as Any)
        DispatchQueue.main.async {
            RestApiController().getAPI(from: "showlalin"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of data Lalin")
                        return
                    }
                    try! self.mapViewlalin.mapboxMap.style.updateGeoJSONSource(withId: self.sourceIdLalin, geoJSON: .featureCollection(featureCollection))
                    try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: self.layaridlalin, type: LineLayer.self){ linelayar in
                        linelayar.source = self.sourceIdLalin
                        let colorExpression = Exp(.match)
                        {
                            Exp(.get) { "color" }
                            "#ffcc00"
                            UIColor(hexString: "#FFCC00")
                            "#ff0000"
                            UIColor(hexString: "#FF0000")
                            "#bb0000"
                            UIColor(hexString: "#BB0000")
                            "#440000"
                            UIColor(hexString: "#440000")
                            "#00ff00"
                            UIColor(hexString: "#00FF00")
                            UIColor.black
                        }
                        linelayar.lineColor = .expression(colorExpression)
                        linelayar.lineCap = .constant(.round)
                        linelayar.lineJoin = .constant(.round)
                    }
                }
            }
        }
    }
    
    @objc func layarHideShow(){
        print("Layar lalin hide/show prosess...")
        DispatchQueue.main.async {
            do {
                try self.mapViewlalin.mapboxMap.style.updateLayer(withId: self.layaridlalin, type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[0] == "yes" ? .visible : .none)
                }
                try self.mapViewlalin.mapboxMap.style.updateLayer(withId: "pemeliharaan", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsEventTol[2] == "yes" ? .visible : .none)
                }
                try self.mapViewlalin.mapboxMap.style.updateLayer(withId: "cctv-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[1] == "yes" ? .visible : .none)
                }
                try self.mapViewlalin.mapboxMap.style.updateLayer(withId: "vms-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[0] == "yes" ? .visible : .none)
                }
            } catch {
                print("gagal hide/show layar")
            }
        }
    }
    
    func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
        timer = Timer()
    }
    
    
}
