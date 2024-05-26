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
    var id : Int {id_ruas}
    let idx: Int
    let id_ruas: Int
    let nama_segment: String
}

class SegmentModel: ObservableObject {
    @Published var showErr: Bool = false
    @Published var errorMsg: String = ""
    
    func getSegment(idruas: Int, completion: @escaping ([Getsegment]) -> ()){
        // segmentation/v1/group_segment?id_ruas=4&jalur=a&tipe=1
        DispatchQueue.global().async {
//            let paramsData: Parameters = ["id_ruas": idruas]
            RestApiController().resAPIGet(endPoint: "segmentation/v1/group_segment?id_ruas="+String(idruas)+"&jalur=a&tipe=1", method: .get){ (results) in
                let getJSON = JSON(results ?? "Null data from API")
                DispatchQueue.main.async {
                    if getJSON["status"].boolValue {
                        do {
                            let jsonData = try JSONEncoder().encode(getJSON["data"])
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
