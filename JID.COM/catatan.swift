//
//  catatan code sebelumnya
//  JID.COM
//
//  Created by Macbook on 10/08/22.
//

//in class
//var accesToken = "sk.eyJ1IjoicGVuZGVrYXIiLCJhIjoiY2w2NHAyaDh3MDA2YTNjcG4ybmNybndrbiJ9.7i4K5ejdllGMswN25Qy53w"

//let myResourceOptions = ResourceOptions(accessToken: accesToken)

//func JSONLalinLocal(from fileName: String) throws -> FeatureCollection? {
//    guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
//        preconditionFailure("File '\(fileName)' not found.")
//    }
//
//    let filePath = URL(fileURLWithPath: path)
//    var featureCollection: FeatureCollection?
//    do {
//        let data = try Data(contentsOf: filePath)
//        featureCollection = try JSONDecoder().decode(FeatureCollection.self, from: data)
//    } catch {
//        print("Error parsing data: \(error)")
//    }
//    return featureCollection
//}
//



//func setUpLineLalin() {
//    guard let featureCollection = try? JSONLalinLocal(from: "lalin") else { return }
//    let geoJSONDataSourceIdentifier = "data-lalin"
//
//    geoJSONSource.data = .featureCollection(featureCollection)
//
//    var lineLayer = LineLayer(id: "lalin")
//    lineLayer.filter = Exp(.eq) {
//        "$type"
//        "LineString"
//    }
//
//    lineLayer.source = geoJSONDataSourceIdentifier
//
//    let colorExpression = Exp(.match)
//    {
//        Exp(.get) { "color" }
//        "#ffcc00"
//        UIColor(hexString: "#FFCC00")
//        "#ff0000"
//        UIColor(hexString: "#FF0000")
//        "#bb0000"
//        UIColor(hexString: "#BB0000")
//        "#440000"
//        UIColor(hexString: "#440000")
//        "#00ff00"
//        UIColor(hexString: "#00FF00")
//        UIColor.black
//    }
//
//    lineLayer.lineColor = .expression(colorExpression)
//    lineLayer.lineWidth = .constant(2.0)
//
//    lineLayer.lineCap = .constant(.round)
//    lineLayer.lineJoin = .constant(.round)
//
//    try! mapView.mapboxMap.style.addSource(geoJSONSource, id: geoJSONDataSourceIdentifier)
//    try! mapView.mapboxMap.style.addLayer(lineLayer, layerPosition: nil)
//}
