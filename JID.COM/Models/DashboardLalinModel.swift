//
//  DashboardLalinModel.swift
//  JID.COM
//
//  Created by Panda on 15/11/23.
//

import UIKit
import MapboxMaps
import SwiftyJSON
import SwiftUI

class DashboardLalinModel: ObservableObject{
    // start class
    func getDataDashRekayasa(completion: @escaping (JSON) -> ())  {
        DispatchQueue.global().async {
            RestApiController().resAPIDevGet(endPoint: "dashboard_lalin/v1/countRekayasa", method: .get) { (results) in
                let getJSON = JSON(results ?? "Null data from API")
                DispatchQueue.main.async {
                    if getJSON["status"].boolValue {
                        do {
                            let jsonDataTh = getJSON["data"]["data"]
                            let jsonDataHari = getJSON["data"]["dataDaily"]
                            let decodedSentences = JSON(
                                ["tahun": jsonDataTh, "hari": jsonDataHari]
                            )
                            completion(decodedSentences)
                        }
                    }else{
                        print(getJSON["msg"].stringValue)
                    }
                }
            }
        }
    }
    
    func getDataDashGangguan(completion: @escaping (JSON) -> ())  {
        DispatchQueue.global().async {
            RestApiController().resAPIDevGet(endPoint: "dashboard_lalin/v1/countGangguan", method: .get) { (results) in
                let getJSON = JSON(results ?? "Null data from API")
                DispatchQueue.main.async {
                    if getJSON["status"].boolValue {
                        do {
                            let jsonDataTh = getJSON["data"]["data"]
                            let jsonDataHari = getJSON["data"]["dataDaily"]
                            let decodedSentences = JSON(
                                ["tahun": jsonDataTh, "hari": jsonDataHari]
                            )
                            completion(decodedSentences)
                        }
                    }else{
                        print(getJSON["msg"].stringValue)
                    }
                }
            }
        }
    }
    // end class
}
