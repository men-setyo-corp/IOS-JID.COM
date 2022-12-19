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
        lineLayer.lineWidth = .constant(3.0)
        
        lineLayer.lineCap = .constant(.round)
        lineLayer.lineJoin = .constant(.round)
         
        // Add the source and style layer to the map style.
        try! mapViewlalin.mapboxMap.style.addSource(geoJSONSource, id: geoJSONDataSourceIdentifier)
        try! mapViewlalin.mapboxMap.style.addLayer(lineLayer, layerPosition: nil)
        
        DispatchQueue.main.async {
            do {
                try self.mapViewlalin.mapboxMap.style.updateLayer(withId: self.layaridlalin, type: LineLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[5] == "yes" ? .visible : .none)
                }
            } catch {
                print("Galam menjalankan proses toggle layer cctv")
            }
           
        }
        
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.setUpdateLayers), userInfo: nil, repeats: true)
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.runLayar), userInfo: nil, repeats: true)
        
    }
    
    @objc func setUpdateLayers(){
        print("Update Lalin is running...")
        DispatchQueue.global().async{
            RestApiController().getAPI(from: "showlalin"){ (returnedData) in
                if let jsonData = try? JSONEncoder().encode(returnedData) {
                    var featureCollection: FeatureCollection!
                    do{
                        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jsonData)
                    }catch{
                        print("Something went wrong of data Lalin")
                        return
                    }
                    DispatchQueue.main.sync {
                        try! self.mapViewlalin.mapboxMap.style.updateGeoJSONSource(withId: self.sourceIdLalin, geoJSON: .featureCollection(featureCollection))
                        try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: self.layaridlalin, type: LineLayer.self){ linelayar in
//                            linelayar.source = self.sourceIdLalin
                            linelayar.filter = Exp(.eq) {
                                "$type"
                                "LineString"
                            }
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
    
    @objc func runLayar(){
        //info jalan toll
        if Dataset.stsInfoJalanTol[0]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "data-toll") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "line-toll", type: LineLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[0] == "yes" ? .visible : .none)
                }
            }else{
                TollModel().setUpLineToll(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "data-toll") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "line-toll", type: LineLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[0] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsInfoJalanTol[1]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-bataskm") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "bataskm-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[1] == "yes" ? .visible : .none)
                }
            }else{
                BatasKmModel().setUpBatasKmAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-bataskm") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "bataskm-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[1] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsInfoJalanTol[2]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "sourcejlnpenghubung") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "jlnpenghubung", type: LineLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[2] == "yes" ? .visible : .none)
                }
            }else{
                JalanPenghubungModel().setUpJlnPengubungAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "sourcejlnpenghubung") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "jlnpenghubung", type: LineLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[2] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsInfoJalanTol[3]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-gerbangtoll") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "gerbangtoll-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[3] == "yes" ? .visible : .none)
                }
            }else{
                GerbangTollModel().setUpGerbagToillPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-gerbangtoll") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "gerbangtoll-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[3] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsInfoJalanTol[4]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-restarea") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "restarea-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[4] == "yes" ? .visible : .none)
                }
            }else{
                RestAreamodel().setUpRestAreaAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-restarea") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "restarea-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[4] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsInfoJalanTol[5]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: self.sourceIdLalin) {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: self.layaridlalin, type: LineLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[5] == "yes" ? .visible : .none)
                }
            }else{
                LalinModel().setUpLalinAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: self.sourceIdLalin) {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: self.layaridlalin, type: LineLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsInfoJalanTol[5] == "yes" ? .visible : .none)
                }
            }
        }
        
        //sisinfokom
        if Dataset.stsSisinfokom[0]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-vms") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "vms-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[0] == "yes" ? .visible : .none)
                }
            }else{
                vmsModel().setUpVMSAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-vms") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "vms-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[0] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsSisinfokom[1]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-cctv") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "cctv-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[1] == "yes" ? .visible : .none)
                }
            }else{
                CctvMapModel().setUpCctvAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-cctv") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "cctv-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[1] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsSisinfokom[2]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-rtms") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "rtms-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[2] == "yes" ? .visible : .none)
                }
            }else{
                RtmsModel().setUpRtmsAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-rtms") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "rtms-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[2] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsSisinfokom[3]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-rtms2") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "rtms2-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[3] == "yes" ? .visible : .none)
                }
            }else{
                Rtms2Model().setUpRtms2API(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-rtms2") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "rtms2-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[3] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsSisinfokom[4]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-radar") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "radar-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[4] == "yes" ? .visible : .none)
                }
            }else{
                RadarModel().setUpRadarAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-radar") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "radar-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[4] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsSisinfokom[5]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-speed") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "speed-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[5] == "yes" ? .visible : .none)
                }
            }else{
                SpeedModel().setUpSpeedAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-speed") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "speed-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[5] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsSisinfokom[6]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-waterlevel"){
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "waterlevel-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[6] == "yes" ? .visible : .none)
                }
            }else{
                WaterLevelModel().setUpWaterLevelAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-waterlevel") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "waterlevel-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[6] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsSisinfokom[7]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-pompa") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "pompa-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[7] == "yes" ? .visible : .none)
                }
            }else{
                PompaBanjirModel().setUpPompaBanjirAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-pompa") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "pompa-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[7] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsSisinfokom[8]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-wim") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "wim-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[8] == "yes" ? .visible : .none)
                }
            }else{
                WimModel().setUpWimAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-wim") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "wim-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[8] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsSisinfokom[9]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-gpskendaraan") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "gpskendaraan-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[9] == "yes" ? .visible : .none)
                }
            }else{
                GpsKendaraanModel().setUpGPSKendaraanAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-gpskendaraan") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "gpskendaraan-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[9] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsSisinfokom[10]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-bike") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "bike-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[10] == "yes" ? .visible : .none)
                }
            }else{
                BikeModel().setUpBikeAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-bike") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "bike-symbol", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsSisinfokom[10] == "yes" ? .visible : .none)
                }
            }
        }
        
        //event jalan toll
        if Dataset.stsEventTol[0]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-gangguanlalin") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "gangguanlalin", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsEventTol[0] == "yes" ? .visible : .none)
                }
            }else{
                GangguanLalinModel().setUpGangguanlalinAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-gangguanlalin") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "gangguanlalin", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsEventTol[0] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsEventTol[1]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-rekayasalalin") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "rekayasalalin", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsEventTol[1] == "yes" ? .visible : .none)
                }
            }else{
                RekayasaLalinModel().setUpRekayasalalinAPI(setmapView: self.mapViewlalin)
            }
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-linerekayasalalin") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "linerekayasalalin", type: LineLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsEventTol[1] == "yes" ? .visible : .none)
                }
            }else{
                LineRekayasaLalinModel().setUpRekayasalalinAPILine(setmapView: self.mapViewlalin)
            }
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-symbollinekayasalalin") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "symbollinerekayasalalin", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsEventTol[1] == "yes" ? .visible : .none)
                }
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-rekayasalalin") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "rekayasalalin", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsEventTol[1] == "yes" ? .visible : .none)
                }
            }
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-linerekayasalalin") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "linerekayasalalin", type: LineLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsEventTol[1] == "yes" ? .visible : .none)
                }
            }
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-symbollinekayasalalin") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "symbollinerekayasalalin", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsEventTol[1] == "yes" ? .visible : .none)
                }
            }
        }
        if Dataset.stsEventTol[2]  == "yes" {
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-pemeiliharaan") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "pemeliharaan", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsEventTol[2] == "yes" ? .visible : .none)
                }
            }else{
                PemeliharaanModel().setUpPemeliharaanAPI(setmapView: self.mapViewlalin)
            }
        }else{
            if self.mapViewlalin.mapboxMap.style.sourceExists(withId: "source-pemeiliharaan") {
                try! self.mapViewlalin.mapboxMap.style.updateLayer(withId: "pemeliharaan", type: SymbolLayer.self) { layer in
                    layer.visibility = .constant(Dataset.stsEventTol[2] == "yes" ? .visible : .none)
                }
            }
        }
    }
    
    
}
