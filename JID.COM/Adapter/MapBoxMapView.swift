//
//  MapBoxMapView.swift
//  JID.COM
//
//  Created by Macbook on 06/08/22.
//

import UIKit
import SwiftUI
import SwiftyJSON
import CoreLocation
import Alamofire
import MapboxMaps

struct MapBoxMapView: UIViewControllerRepresentable {
     
    func makeUIViewController(context: Context) -> MapViewController {
       return MapViewController()
    }
      
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        //as all function Update for view mapbox
    }
    
}

class MapViewController: UIViewController {
    
    var mapView: MapView!
    
    var locationManager = CLLocationManager()
           
    func setupManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupManager()
       
        let myMapInitOptions = MapInitOptions(styleURI: .light)

        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        mapView.mapboxMap.setCamera(
            to: CameraOptions(
                center: CLLocationCoordinate2D(
                    latitude: -2.3932282,
                    longitude: 108.8450721
                ),
                zoom: 3.5,
                bearing: 0,
                pitch: 0
            )
        )
        mapView.mapboxMap.onNext(event: .mapLoaded) { _ in
            TollModel().setUpLineToll(setmapView: self.mapView)
            DispatchQueue.main.async {
                LalinModel().setUpLalinAPI(setmapView: self.mapView)
                
                //info jalan toll
                if Dataset.stsInfoJalanTol[1]  == "yes" {
                    BatasKmModel().setUpBatasKmAPI(setmapView: self.mapView)
                }
                if Dataset.stsInfoJalanTol[2]  == "yes" {
                    JalanPenghubungModel().setUpJlnPengubungAPI(setmapView: self.mapView)
                }
                if Dataset.stsInfoJalanTol[3]  == "yes" {
                    GerbangTollModel().setUpGerbagToillPI(setmapView: self.mapView)
                }
                if Dataset.stsInfoJalanTol[4]  == "yes" {
                    RestAreamodel().setUpRestAreaAPI(setmapView: self.mapView)
                }
                
                //sisinfokom
                if Dataset.stsSisinfokom[0]  == "yes" {
                    vmsModel().setUpVMSAPI(setmapView: self.mapView)
                }
                if Dataset.stsSisinfokom[1]  == "yes" {
                    CctvMapModel().setUpCctvAPI(setmapView: self.mapView)
                }
                if Dataset.stsSisinfokom[2]  == "yes" {
                    RtmsModel().setUpRtmsAPI(setmapView: self.mapView)
                }
                if Dataset.stsSisinfokom[3]  == "yes" {
                    Rtms2Model().setUpRtms2API(setmapView: self.mapView)
                }
                if Dataset.stsSisinfokom[4]  == "yes" {
                    RadarModel().setUpRadarAPI(setmapView: self.mapView)
                }
                if Dataset.stsSisinfokom[5]  == "yes" {
                    SpeedModel().setUpSpeedAPI(setmapView: self.mapView)
                }
                if Dataset.stsSisinfokom[6]  == "yes" {
                    WaterLevelModel().setUpWaterLevelAPI(setmapView: self.mapView)
                }
                if Dataset.stsSisinfokom[7]  == "yes" {
                    PompaBanjirModel().setUpPompaBanjirAPI(setmapView: self.mapView)
                }
                if Dataset.stsSisinfokom[8]  == "yes" {
                    WimModel().setUpWimAPI(setmapView: self.mapView)
                }
                if Dataset.stsSisinfokom[9]  == "yes" {
                    GpsKendaraanModel().setUpGPSKendaraanAPI(setmapView: self.mapView)
                }
                if Dataset.stsSisinfokom[10]  == "yes" {
                    BikeModel().setUpBikeAPI(setmapView: self.mapView)
                }
                
                //event jalan toll
                if Dataset.stsEventTol[0]  == "yes" {
                    GangguanLalinModel().setUpGangguanlalinAPI(setmapView: self.mapView)
                }
                if Dataset.stsEventTol[1]  == "yes" {
                    RekayasaLalinModel().setUpRekayasalalinAPI(setmapView: self.mapView)
                    LineRekayasaLalinModel().setUpRekayasalalinAPILine(setmapView: self.mapView)
                }
                if Dataset.stsEventTol[2]  == "yes" {
                    PemeliharaanModel().setUpPemeliharaanAPI(setmapView: self.mapView)
                }
                
            }
        }
        
        //set ornamnents and gestures default mapbox
        mapView.gestures.options.rotateEnabled = false
        mapView.ornaments.attributionButton.isHidden = true
        mapView.ornaments.logoView.isHidden = false
        
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMapClick)))
        
        view.addSubview(mapView)
        
    }
    
    //set onclick
    @objc private func onMapClick(_ sender: UITapGestureRecognizer) {
        let screenPoint = sender.location(in: mapView)
        let queryOptions = RenderedQueryOptions(layerIds: ["pemeliharaan","lalin","cctv-symbol","vms-symbol", "gangguanlalin","rekayasalalin", "gerbangtoll-symbol","restarea-symbol", "rtms-symbol", "rtms2-symbol", "radar-symbol", "speed-symbol", "waterlevel-symbol","pompa-symbol", "wim-symbol"], filter: nil)
        mapView.mapboxMap.queryRenderedFeatures(with: screenPoint, options: queryOptions) { result in
            guard let feature = try? result.get().first?.feature else {
                return
            }
            do{
                let encodedData = try JSONEncoder().encode(feature.properties)
                let objData = JSON(encodedData)
                if objData.isEmpty {
                    print("data object kosong")
                }else{
                    if objData["title"].stringValue == "kondisilalin" {
                        print("informasi kondisi lalin")
                    }else if objData["title"].stringValue == "pemeliharaan"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "cctv"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "vms"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "gangguanlalin"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "rekayasalalin"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "gerbang tol"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "rest area"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "rtms"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "rtms2"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "radar"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "speed counting"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "water level"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "pompa banjir"{
                        self.modalSheet(dataSet: objData)
                    }else if objData["title"].stringValue == "wim"{
                        self.modalSheet(dataSet: objData)
                    }
                }
            }catch{
                print("failed to convert \(error.localizedDescription)")
            }
        }
    }
    
    private func modalSheet(dataSet: JSON){
        if dataSet["title"].stringValue == "pemeliharaan" {
            let writerForSecondView = Dataset().Dataset_pemeliharaan(dataSet: dataSet)
            let nav = UIHostingController(rootView: PemeliharaanComponent(writer: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .white
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.medium(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "gangguanlalin" {
            let writerForSecondView = Dataset().Dataset_gangguan(dataSet: dataSet)
            let nav = UIHostingController(rootView: GangguanModal(writer: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .white
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.medium(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "rekayasalalin" {
            let writerForSecondView = Dataset().Dataset_pemeliharaan(dataSet: dataSet)
            let nav = UIHostingController(rootView: RekayasaLalinModal(writer: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .white
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.medium(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "cctv" {
            let writerForSecondView = Dataset().Dataset_cctv(dataSet: dataSet)
            let nav = UIHostingController(rootView: SnapImgSingle(dataSnap: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .clear
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.large(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "cctv list"{
            let nav = UIHostingController(rootView: SnapImage())
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .clear
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.large(), .medium()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "vms" {
            let writerForSecondView = Dataset().Dataset_vms(dataSet: dataSet)
            let nav = UIHostingController(rootView: vmsModal(dataResult: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .clear
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.large(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "gerbang tol" {
            let writerForSecondView = Dataset().Dataset_gerbangtoll(dataSet: dataSet)
            let nav = UIHostingController(rootView: GerbangTollModal(writer: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .white
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.medium(), .medium()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "rest area" {
            let writerForSecondView = Dataset().Dataset_restarea(dataSet: dataSet)
            let nav = UIHostingController(rootView: ResAreaModal(dataResult: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .clear
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.large(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "rtms" {
            let writerForSecondView = Dataset().Dataset_rtms(dataSet: dataSet)
            let nav = UIHostingController(rootView: RtmsModal(writer: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .white
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.medium(), .medium()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "rtms2" {
            let writerForSecondView = Dataset().Dataset_rtms2(dataSet: dataSet)
            let nav = UIHostingController(rootView: Rtms2Modal(dataResult: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .clear
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.large(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "radar" {
            let writerForSecondView = Dataset().Dataset_radar(dataSet: dataSet)
            let nav = UIHostingController(rootView: RadarModal(writer: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .white
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.medium(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "speed counting" {
            let writerForSecondView = Dataset().Dataset_speed(dataSet: dataSet)
            let nav = UIHostingController(rootView: SpeedModal(writer: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .white
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.medium(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "water level" {
            let writerForSecondView = Dataset().Dataset_wakterlevel(dataSet: dataSet)
            let nav = UIHostingController(rootView: WaterLevelModal(writer: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .white
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.medium(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "pompa banjir" {
            let writerForSecondView = Dataset().Dataset_pompa(dataSet: dataSet)
            let nav = UIHostingController(rootView: PompaBanjirModal(writer: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .white
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.medium(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }
        else if dataSet["title"].stringValue == "wim" {
            let writerForSecondView = Dataset().Dataset_wim(dataSet: dataSet)
            let nav = UIHostingController(rootView: WimModal(writer: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .white
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.medium(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }
    }


    
}

