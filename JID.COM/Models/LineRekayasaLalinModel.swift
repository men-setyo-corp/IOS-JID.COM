//
//  LineRekayasaLalinModel.swift
//  JID.COM
//
//  Created by Panda on 15/12/22.
//
import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI

class LineRekayasaLalinModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceData = "source-linerekayasalalin"
    let sourceDatasymbolline = "source-symbollinekayasalalin"
    var mapView: MapView!
    var timer = Timer()
    var sizeIcon: Double = 0.6
    
    
    func setUpRekayasalalinAPILine(setmapView: MapView)  {
        print("run layar linerekayasalalin...")
        DispatchQueue.global().async{
            RestApiController().getAPILine(from: "rekayasalalin"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of data FeatureCollection linerekayasalalin...")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    
                    var lineLayer = LineLayer(id: "linerekayasalalin")
                    lineLayer.filter = Exp(.eq) {
                        "$type"
                        "LineString"
                    }
                    lineLayer.source =  self.sourceData
                    
                    lineLayer.lineColor = .constant(StyleColor(UIColor(hexString: "#4b9dff")))
                    lineLayer.lineWidth = .constant(1.2)
                    lineLayer.lineCap = .constant(.round)
                    lineLayer.lineJoin = .constant(.round)
                    
                    try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceData)
                    try! setmapView.mapboxMap.style.addLayer(lineLayer, layerPosition: nil)
                    
                    self.mapView = setmapView
                    
                    DispatchQueue.main.async {
                        do {
                            try self.mapView.mapboxMap.style.updateLayer(withId: "linerekayasalalin", type: LineLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsEventTol[1] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Galam menjalankan proses toggle layer linerekayasalalin")
                        }
                        self.setUpRekayasalalinAPIsymbol(setmapView: self.mapView)
                    }
                    
                    self.timer.invalidate()
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 100, target: self, selector: #selector(self.setUpdateLayersLineRekayasalalin), userInfo: nil, repeats: true)
                    
                    
                }
            }
        }
    }
    
    func setUpRekayasalalinAPIsymbol(setmapView: MapView)  {
        DispatchQueue.global().async{
            RestApiController().getAPILine(from: "rekayasalalin"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of data FeatureCollection rekayasalalin...")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "arrow_line_biru")!,
                                                             id: "arrow")
                    
                    var symbollayer = SymbolLayer(id: "symbollinerekayasalalin")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "LineString"
                    }
                    symbollayer.source = self.sourceDatasymbolline
                    symbollayer.iconImage = .constant(.name("arrow"))
                    symbollayer.iconSize = .constant(0.5)
                    symbollayer.symbolPlacement = .constant(SymbolPlacement.line)
                    symbollayer.iconAllowOverlap = .constant(false)
                    symbollayer.symbolSpacing = .constant(5)
                    
                    try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceDatasymbolline)
                    try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    
                    DispatchQueue.main.async {
                        do {
                            try self.mapView.mapboxMap.style.updateLayer(withId: "symbollinerekayasalalin", type: SymbolLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsEventTol[1] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Galam menjalankan proses toggle layer linerekayasalalin")
                        }
                        
                    }
                    
                    
                }
            }
        }
    }
    
    @objc func setUpdateLayersLineRekayasalalin(){
        print("Update linerekayasalalin is running...")
        DispatchQueue.global(qos: .background).async {
            RestApiController().getAPI(from: "rekayasalalin"){ (returnedData) in
                DispatchQueue.main.async {
                    if let jsonData = try? JSONEncoder().encode(returnedData) {
                        var featureCollection: FeatureCollection!
                        do{
                            featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                        }catch{
                            print("Something went wrong of data linerekayasalalin realtime...")
                            return
                        }
         
                        try! self.mapView.mapboxMap.style.updateGeoJSONSource(withId: self.sourceData, geoJSON: .featureCollection(featureCollection))
                        try! self.mapView.mapboxMap.style.updateLayer(withId: "linerekayasalalin", type: LineLayer.self){ linelayer in
                            linelayer.source = self.sourceData
                            linelayer.lineColor = .constant(StyleColor(UIColor.init(hexString: "#2c89fb")))
                        }
                    }
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
