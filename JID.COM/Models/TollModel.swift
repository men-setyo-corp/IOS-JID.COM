//
//  TollModel.swift
//  JID.COM
//
//  Created by Macbook on 22/08/22.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI


class TollModel: ObservableObject{
    
    var geoJSONSource = GeoJSONSource()
    
    //load json from local directory
    func JSONLalinToll(from fileName: String) throws -> FeatureCollection? {
//        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
//            preconditionFailure("File '\(fileName)' not found.")
//        }

//        let filePath = URL(fileURLWithPath: path)
        var featureCollection: FeatureCollection?
        do {
//            let data = try Data(contentsOf: filePath)
            featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: jalantol)
        } catch {
            print("Error parsing data: \(error)")
        }
        return featureCollection
    }
    
    // setUp line json Toll
    func setUpLineToll(setmapView: MapView)  {
        guard let featureCollection = try? JSONLalinToll(from: "toll") else { return }
        let geoJSONDataSourceIdentifier = "data-toll"
        
        geoJSONSource.data = .featureCollection(featureCollection)
         
        var lineLayer = LineLayer(id: "line-toll")
        lineLayer.filter = Exp(.eq) {
            "$type"
            "LineString"
        }
        lineLayer.source = geoJSONDataSourceIdentifier
    
        lineLayer.lineColor = .constant(StyleColor(.darkGray))
        lineLayer.lineWidth = .constant(3.0)
        lineLayer.lineCap = .constant(.round)
        lineLayer.lineJoin = .constant(.round)
         
        // Add the source and style layer to the map style.
        try! setmapView.mapboxMap.style.addSource(geoJSONSource, id: geoJSONDataSourceIdentifier)
        try! setmapView.mapboxMap.style.addLayer(lineLayer, layerPosition: nil)
        
    }
    
    
}
