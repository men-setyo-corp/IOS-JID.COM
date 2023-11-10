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
    let id : String
    let akun : String
    let tipe_event: String
    let ket_jenis_event: String
    let detail_ket_jenis_event : String
    let ket_status  : String
    let km : String
    let jalur : String
    let nama_ruas : String
    let tanggal : String
    let created_at : String
}

class HistoriNotifModel: ObservableObject {
  
    func loadHistori(completion: @escaping ([Gethistori]) -> ()) {
        let parameters : Parameters = ["limit": 30, "platform": "jid_mobile"]
        DispatchQueue.main.async {
            RestApiController().resAPI(endPoint: "push_notif/getallios", method: .post ,dataParam: parameters){ (results) in
                let getJSON = JSON(results ?? "Null data from API")
                
                if getJSON["status"].intValue == 1 {
                    do {
                        let jsonData = try JSONEncoder().encode(getJSON["datares"])
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
