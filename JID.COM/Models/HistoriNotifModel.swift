//
//  HistoriNotifModel.swift
//  JID.COM
//
//  Created by Panda on 21/12/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct Gethistori: Codable, Identifiable {
    let tipe_event: String
    let ket_jenis_event: String
    let detail_ket_jenis_event : String
    let ket_status  : String
    let km : String
    let jalur : String
    let nama_ruas : String
    
    var id = UUID()
}

class HistoriNotifModel: ObservableObject {
  
    func loadHistori(completion: @escaping ([Gethistori]) -> ()) {
        let parameters : Parameters = ["limit": 10, "platform": "jid_mobile"]
        DispatchQueue.main.async {
            RestApiController().resAPI(endPoint: "push_notif/getAll", method: .post ,dataParam: parameters){ (results) in
                let getJSON = JSON(results ?? "Null data from API")
                
                if getJSON["status"].intValue == 1 {
                    do {
                        let jsonData = try JSONEncoder().encode(getJSON["data"])
                        print(jsonData)
                        let decodedSentences = try JSONDecoder().decode([Gethistori].self, from: jsonData)
                        completion(decodedSentences)
                    } catch let myJSONError {
                        print(myJSONError)
                    }
                }else{
                    print(getJSON["msg"].stringValue)
                }
            }
        }
    }
    
    
}
