//
//  RekaysaLalinModel.swift
//  JID.COM
//
//  Created by Panda on 15/12/22.
//
import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI

class RekayasaLalinModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceData = "source-rekayasalalin"
    var mapView: MapView!
    var timer = Timer()
    var sizeIcon: Double = 0.8
    
    
    func setUpRekayasalalinAPI(setmapView: MapView)  {
        print("run layar rekayasalalin...")
        DispatchQueue.global().async{
            RestApiController().getAPI(from: "rekayasalalin"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of data FeatureCollection rekayasalalin...")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "control_32")!,
                                                             id: "icon_rekayasalalin")
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "noway_24")!,
                                                             id: "pengalihan")
                    
                    var symbollayer = SymbolLayer(id: "rekayasalalin")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    let expressionIcon = Exp(.switchCase) {
                        Exp(.eq) {
                            Exp(.get) { "icon" }
                                "rekayasapengalihan"
                            }
                        "pengalihan"
                        Exp(.eq) {
                            Exp(.get) { "icon" }
                                "rekayasalalinimg"
                            }
                        "icon_rekayasalalin"
                        "pengalihan"
                    }
                    
                    symbollayer.source = self.sourceData
                    symbollayer.iconImage = .expression(expressionIcon)
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"ket_jenis_kegiatan"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.4)
                    symbollayer.iconAllowOverlap = .constant(true)
                    
                    if setmapView.mapboxMap.style.sourceExists(withId: self.sourceData) == false {
                        try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceData)
                        try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    }
                    
                    
                    self.mapView = setmapView
                    
                    DispatchQueue.main.async {
                        do {
                            try self.mapView.mapboxMap.style.updateLayer(withId: "rekayasalalin", type: SymbolLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsEventTol[1] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Galam menjalankan proses toggle layer rekayasalalin")
                        }
                        
                    }
                    
                    self.timer.invalidate()
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 100, target: self, selector: #selector(self.setUpdateLayersRekayasalalin), userInfo: nil, repeats: true)
                    
                    
                }
            }
        }
    }
    
    @objc func setUpdateLayersRekayasalalin(){
        print("Update rekayasalalin is running...")
        DispatchQueue.global(qos: .background).async {
            RestApiController().getAPI(from: "rekayasalalin"){ (returnedData) in
                DispatchQueue.main.async {
                    if let jsonData = try? JSONEncoder().encode(returnedData) {
                        var featureCollection: FeatureCollection!
                        do{
                            featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                        }catch{
                            print("Something went wrong of data rekayasalalin realtime...")
                            return
                        }
         
                        try! self.mapView.mapboxMap.style.updateGeoJSONSource(withId: self.sourceData, geoJSON: .featureCollection(featureCollection))
                        try! self.mapView.mapboxMap.style.updateLayer(withId: "rekayasalalin", type: SymbolLayer.self){ symbollayar in
                            symbollayar.source = self.sourceData
                            symbollayar.iconImage = .constant(.name("icon_rekayasalalin"))
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


