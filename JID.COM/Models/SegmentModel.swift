//
//  SegmentModel.swift
//  JID.COM
//
//  Created by Macbook on 27/09/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct Getsegment: Codable, Identifiable {
    let id: Int
    let idx: Int
    let id_ruas: Int
    let nama_segment: String
}

class SegmentModel: ObservableObject {
    @Published var showErr: Bool = false
    @Published var errorMsg: String = ""
    
    func getSegment(idruas: Int, completion: @escaping ([Getsegment]) -> ()){
        DispatchQueue.global().async {
            let paramsData: Parameters = ["id_ruas": idruas]
            RestApiController().resAPI(endPoint: "data/segment", method: .put, dataParam: paramsData){ (results) in
                let getJSON = JSON(results ?? "Null data from API")
                DispatchQueue.main.async {
                    if getJSON["status"].intValue == 1 {
                        do {
                            let jsonData = try JSONEncoder().encode(getJSON["results"])
                            let decodedSentences = try JSONDecoder().decode([Getsegment].self, from: jsonData)
                            completion(decodedSentences)
                        } catch let myJSONError {
                            print(myJSONError)
                        }
                    }else{
                        self.errorMsg = getJSON["msg"].stringValue
                        self.showErr.toggle()
                    }
                }
            }
        }
    }
    
}
