//
//  CctvMapModel.swift
//  JID.COM
//
//  Created by Macbook on 28/09/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class CctvMapModel: ObservableObject{

    var geoJSONSource = GeoJSONSource()
    let sourceDataCctv = "source-cctv"
    var mapView: MapView!
    var timer = Timer()
    var sizeIcon: Double = 0.9
    
    
    func setUpCctvAPI(setmapView: MapView)  {
        print("run layar cctv...")
        DispatchQueue.global().async {
            RestApiController().getAPI(from: "showcctv"){ (returnedData) in
            if let jsonData = try? JSONEncoder().encode(returnedData) {
                var featureCollection: FeatureCollection!
                do{
                    featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                }catch{
                    print("Something went wrong of featurecollection data cctv")
                    return
                }
                self.geoJSONSource.data = .featureCollection(featureCollection)
                
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "cctv_b_24")!,
                                                         id: "main_rood_on")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "cctv_r_24")!,
                                                         id: "main_rood_off")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "arteri_off")!,
                                                         id: "arteri_off")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "arteri_on")!,
                                                         id: "arteri_on")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "genangan_off")!,
                                                         id: "genangan_off")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "genangan_on")!,
                                                         id: "genangan_on")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "gerbang_off")!,
                                                         id: "gerbang_off")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "gerbang_on")!,
                                                         id: "gerbang_on")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "ss_off")!,
                                                         id: "ss_off")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "ss_on")!,
                                                         id: "ss_on")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "ramp_off")!,
                                                         id: "ramp_off")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "ramp_on")!,
                                                         id: "ramp_on")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "elevated_on")!,
                                                         id: "elevated_on")
                try! setmapView.mapboxMap.style.addImage(UIImage(named: "elevated_off")!,
                                                         id: "elevated_off")
                
                var symbollayer = SymbolLayer(id: "cctv-symbol")
                symbollayer.filter = Exp(.eq) {
                    "$type"
                    "Point"
                }
                
                symbollayer.source = self.sourceDataCctv
                
                let expressionIcon = Exp(.switchCase) {
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "main_rood_on"
                        }
                    "main_rood_on"
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "main_rood_off"
                        }
                    "main_rood_off"
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "arteri_off"
                        }
                    "arteri_off"
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "arteri_on"
                        }
                    "arteri_on"
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "genangan_off"
                        }
                    "genangan_off"
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "genangan_on"
                        }
                    "genangan_on"
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "gerbang_off"
                        }
                    "gerbang_off"
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "gerbang_on"
                        }
                    "gerbang_on"
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "ss_off"
                        }
                    "ss_off"
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "ss_on"
                        }
                    "ss_on"
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "ramp_off"
                        }
                    "ramp_off"
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "ramp_on"
                        }
                    "ramp_on"
                    
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "elevated_on"
                        }
                    "elevated_on"
                    Exp(.eq) {
                        Exp(.get) { "poi" }
                            "elevated_off"
                        }
                    "elevated_off"
                    "main_rood_on"
                }
                
                symbollayer.iconImage = .expression(expressionIcon)
                
                symbollayer.iconSize = .constant(self.sizeIcon)
                symbollayer.textField = .expression(Exp(.get){"nama"})
                symbollayer.textSize = .constant(8)
                symbollayer.textJustify = .constant(.center)
                symbollayer.textAnchor = .constant(.top)
                symbollayer.textRadialOffset = .constant(1.6)
                
                if setmapView.mapboxMap.style.sourceExists(withId: "source-cctv") == false {
                    try! setmapView.mapboxMap.style.addSource(self.geoJSONSource, id: self.sourceDataCctv)
                    try! setmapView.mapboxMap.style.addLayer(symbollayer, layerPosition: nil)
                }
                
                
                
                self.mapView = setmapView
                
                DispatchQueue.main.async {
                    do {
                        try self.mapView.mapboxMap.style.updateLayer(withId: "cctv-symbol", type: SymbolLayer.self) { layer in
                            layer.visibility = .constant(Dataset.stsSisinfokom[1] == "yes" ? .visible : .none)
                        }
                    } catch {
                        print("Gagal menjalankan proses toggle layer cctv")
                    }
                    
                }
//                self.timer.invalidate()
//                self.timer = Timer.scheduledTimer(timeInterval: 110, target: self, selector: #selector(self.setUpdateLayersCctv), userInfo: nil, repeats: true)
//                
                
            }
        }
        }
    }
    
    @objc func setUpdateLayersCctv(){
        print("Update Cctv is running...")
        DispatchQueue.global(qos: .background).async {
            RestApiController().getAPI(from: "showcctv"){ (returnedData) in
                DispatchQueue.main.async {
                    if let jsonData = try? JSONEncoder().encode(returnedData) {
                        var featureCollection: FeatureCollection!
                        do{
                            featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                        }catch{
                            print("Something went wrong of data CCTV")
                            return
                        }
         
                        try! self.mapView.mapboxMap.style.updateGeoJSONSource(withId: self.sourceDataCctv, geoJSON: .featureCollection(featureCollection))
                        try! self.mapView.mapboxMap.style.updateLayer(withId: "cctv-symbol", type: SymbolLayer.self){ symbollayar in
                            symbollayar.source = self.sourceDataCctv
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "cctv_b_24")!,
                                                                     id: "main_rood_on")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "cctv_r_24")!,
                                                                     id: "main_rood_off")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "arteri_off")!,
                                                                     id: "arteri_off")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "arteri_on")!,
                                                                     id: "arteri_on")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "genangan_off")!,
                                                                     id: "genangan_off")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "genangan_on")!,
                                                                     id: "genangan_on")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "gerbang_off")!,
                                                                     id: "gerbang_off")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "gerbang_on")!,
                                                                     id: "gerbang_on")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "ss_off")!,
                                                                     id: "ss_off")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "ss_on")!,
                                                                     id: "ss_on")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "ramp_off")!,
                                                                     id: "ramp_off")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "ramp_on")!,
                                                                     id: "ramp_on")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "elevated_on")!,
                                                                     id: "elevated_on")
                            try! self.mapView.mapboxMap.style.addImage(UIImage(named: "elevated_off")!,
                                                                     id: "elevated_off")
                            
                            let expressionIcon = Exp(.switchCase) {
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "main_rood_on"
                                    }
                                "icon_cctv_on"
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "main_rood_off"
                                    }
                                "icon_cctv_off"
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "arteri_off"
                                    }
                                "arteri_off"
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "arteri_on"
                                    }
                                "arteri_on"
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "genangan_off"
                                    }
                                "genangan_off"
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "genangan_on"
                                    }
                                "genangan_on"
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "gerbang_off"
                                    }
                                "gerbang_off"
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "gerbang_on"
                                    }
                                "gerbang_on"
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "ss_off"
                                    }
                                "ss_off"
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "ss_on"
                                    }
                                "ss_on"
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "ramp_off"
                                    }
                                "ramp_off"
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "ramp_on"
                                    }
                                "ramp_on"
                                
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "elevated_on"
                                    }
                                "elevated_on"
                                Exp(.eq) {
                                    Exp(.get) { "poi" }
                                        "elevated_off"
                                    }
                                "elevated_off"
                                "main_rood_on"
                            }
                            
                            symbollayar.iconImage = .expression(expressionIcon)
                            
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
