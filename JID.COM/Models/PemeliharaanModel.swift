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


class PemeliharaanModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceData = "source-pemeiliharaan"
    var mapView: MapView!
    var timer = Timer()
    var sizeIcon: Double = 0.6
    
    
    func setUpPemeliharaanAPI(setmapView: MapView)  {
        print("run layar pemeliharaan...")
        DispatchQueue.global().async{
            RestApiController().getAPI(from: "pemeliharaan"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of data FeatureCollection pemeliharaan...")
                        return
                    }
                    self.geoJSONSource.data = .featureCollection(featureCollection)
                    
                    try! setmapView.mapboxMap.style.addImage(UIImage(named: "repair_32")!,
                                                             id: "icon_pemeliharaan")
                    
                    var symbollayer = SymbolLayer(id: "pemeliharaan")
                    symbollayer.filter = Exp(.eq) {
                        "$type"
                        "Point"
                    }
                    
                    symbollayer.source = self.sourceData
                    symbollayer.iconImage = .constant(.name("icon_pemeliharaan"))
                    symbollayer.iconSize = .constant(self.sizeIcon)
                    symbollayer.textField = .expression(Exp(.get){"ket_jenis_kegiatan"})
                    symbollayer.textSize = .constant(8)
                    symbollayer.textJustify = .constant(.center)
                    symbollayer.textAnchor = .constant(.top)
                    symbollayer.textRadialOffset = .constant(1.4)
                    symbollayer.iconAllowOverlap = .constant(false)
                    
                    if setmapView.mapboxMap.style.sourceExists(withId: "source-pemeiliharaan") == false {
                        try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceData)
                        try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                    }
                   
                    
                    self.mapView = setmapView
                    
                    DispatchQueue.main.async {
                        do {
                            try self.mapView.mapboxMap.style.updateLayer(withId: "pemeliharaan", type: SymbolLayer.self) { layer in
                                layer.visibility = .constant(Dataset.stsEventTol[2] == "yes" ? .visible : .none)
                            }
                        } catch {
                            print("Galam menjalankan proses toggle layer pemeliharaan")
                        }
                        
                    }
                    
                    self.timer.invalidate()
                    
                    self.timer = Timer.scheduledTimer(timeInterval: 100, target: self, selector: #selector(self.setUpdateLayersPemeliharaan), userInfo: nil, repeats: true)
                    
                    
                }
            }
        }
    }
    
    @objc func setUpdateLayersPemeliharaan(){
        print("Update Pemeliharaan is running...")
        DispatchQueue.global(qos: .background).async {
            RestApiController().getAPI(from: "pemeliharaan"){ (returnedData) in
                DispatchQueue.main.async {
                    if let jsonData = try? JSONEncoder().encode(returnedData) {
                        var featureCollection: FeatureCollection!
                        do{
                            featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                        }catch{
                            print("Something went wrong of data Pemeliharaan realtime...")
                            return
                        }
         
                        try! self.mapView.mapboxMap.style.updateGeoJSONSource(withId: self.sourceData, geoJSON: .featureCollection(featureCollection))
                        try! self.mapView.mapboxMap.style.updateLayer(withId: "pemeliharaan", type: SymbolLayer.self){ symbollayar in
                            symbollayar.source = self.sourceData
                            symbollayar.iconImage = .constant(.name("icon_pemeliharaan"))
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
