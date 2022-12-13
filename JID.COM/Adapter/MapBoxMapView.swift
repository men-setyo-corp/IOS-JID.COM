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
            }
        }
        
        //set ornamnents and gestures default mapbox
        mapView.gestures.options.rotateEnabled = false
        mapView.ornaments.attributionButton.isHidden = true
        mapView.ornaments.logoView.isHidden = true
        
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onMapClick)))
        
        view.addSubview(mapView)
        
    }
    
    //set onclick
    @objc private func onMapClick(_ sender: UITapGestureRecognizer) {
        let screenPoint = sender.location(in: mapView)
        let queryOptions = RenderedQueryOptions(layerIds: ["pemeliharaan","lalin","cctv-symbol","vms-symbol"], filter: nil)
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
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.medium(), .large()]
            }
            present(nav, animated: true, completion: nil)
        }else if dataSet["title"].stringValue == "gangguanlalin" {
            //
        }else if dataSet["title"].stringValue == "rekayasalalin" {
            //
        }else if dataSet["title"].stringValue == "cctv" {
            let writerForSecondView = Dataset().Dataset_cctv(dataSet: dataSet)
            let nav = UIHostingController(rootView: SnapImgSingle(dataSnap: writerForSecondView))
            nav.modalPresentationStyle = .pageSheet
            nav.view.backgroundColor = .clear
            if let sheet = nav.sheetPresentationController{
                sheet.detents = [.large(), .medium()]
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
                sheet.detents = [.large(), .medium()]
            }
            present(nav, animated: true, completion: nil)
        }
        
    }


    
}

