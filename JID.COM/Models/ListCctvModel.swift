//
//  ListCctvModel.swift
//  JID.COM
//
//  Created by Macbook on 27/09/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct Getcctv: Codable, Identifiable {
    var id: Int {arteri}
    let id_ruas: String
    let camera_id: String
    let id_segment: String
    let nama: String
    let arteri : Int
    let key_id: String
    let nama_segment: String
    let is_hls: Bool
    let km: String
}

struct GetcctvByruas: Codable, Identifiable {
    let id: Int
    let camera_id: Int
    let nama: String
    let status : String
    let km : String
    let cabang: String
    let key_id: String
}

struct Getcctvsnonjm: Codable, Identifiable {
    let id: Int
    let camera_id: Int
    let nama: String
    let status : String
    let cabang: String
    let key_id: String
}

class ListCctvModel: ObservableObject {
    @Published var showErr: Bool = false
    @Published var errorMsg: String = ""
    
    func getCctv(idruas: Int, nama_segment: String,completion: @escaping ([Getcctv]) -> ()){
        DispatchQueue.global().async {
            // let paramsData: Parameters = ["id_ruas": String(idruas), "id_segment": String(idsegment)]
            // cctv/matrix/v1/show?segment_name=SS+CAWANG+-+TEBET&ruas_id=2&limit=6&offset=0
            // https://api-provider-jid.jasamarga.com/cctv/matrix/v1/show?segment_name=KM+10%2B000+L+-+KM+13%2B700+L&ruas_id=29&limit=6&offset=0
            let replaceplus = nama_segment.replacingOccurrences(of: "+", with: "%2B")
            let replaceStr = replaceplus.replacingOccurrences(of: " ", with: "+")
            RestApiController().resAPIGet(endPoint: "cctv/matrix/v1/show?segment_name="+replaceStr+"&ruas_id="+String(idruas)+"&limit=500&offset=0", method: .get){ (results) in
                let getJSON = JSON(results ?? "Null data from API")
                DispatchQueue.main.async {
                    print(getJSON)
                    if getJSON["rows"].count > 0 {
                        self.showErr.toggle()
                        do {
                            let jsonData = try JSONEncoder().encode(getJSON["rows"])
                            let decodedSentences = try JSONDecoder().decode([Getcctv].self, from: jsonData)
                            completion(decodedSentences)
                        } catch let myJSONError {
                            print(myJSONError)
                        }
                    }else{
                        self.errorMsg = "Data CCTV Kosong !"
                        self.showErr.toggle()
                    }
                }
            }
        }
    }
    
    func getCctvNonJM(idruas: Int, idsegment: Int,completion: @escaping ([Getcctvsnonjm]) -> ()){
        DispatchQueue.global().async {
            let paramsData: Parameters = ["id_ruas": idruas, "id_segment": String(idsegment)]
            RestApiController().resAPI(endPoint: "client-api/segment/cctv", method: .put, dataParam: paramsData){ (results) in
                let getJSON = JSON(results ?? "Null data from API")
                DispatchQueue.main.async {
                    if getJSON["status"].intValue == 1 {
                        if getJSON["results"].count > 0 {
                            self.showErr.toggle()
                            do {
                                let jsonData = try JSONEncoder().encode(getJSON["results"])
                                let decodedSentences = try JSONDecoder().decode([Getcctvsnonjm].self, from: jsonData)
                                completion(decodedSentences)
                            } catch let myJSONError {
                                print(myJSONError)
                            }
                        }else{
                            self.showErr.toggle()
                        }
                    }else{
                        print(getJSON["msg"].stringValue)
                        self.errorMsg = getJSON["msg"].stringValue
                        self.showErr.toggle()
                    }
                }
            }
        }
    }
    
    func getCctvByruas(idruas: Int, completion: @escaping ([GetcctvByruas]) -> ()){
        DispatchQueue.global().async {
            let paramsData: Parameters = ["id_ruas": idruas]
            RestApiController().resAPI(endPoint: "client-api/data/cctv", method: .put, dataParam: paramsData){ (results) in
                let getJSON = JSON(results ?? "Null data from API")
                DispatchQueue.main.async {
                    if getJSON["status"].intValue == 1 {
                        print(getJSON["results"].count)
                        if getJSON["results"].count > 0 {
                            self.showErr.toggle()
                            do {
                                let jsonData = try JSONEncoder().encode(getJSON["results"])
                                let decodedSentences = try JSONDecoder().decode([GetcctvByruas].self, from: jsonData)
                                completion(decodedSentences)
                            } catch let myJSONError {
                                print(myJSONError)
                            }
                        }else{
                            self.showErr.toggle()
                        }
                    }else{
                        print(getJSON["msg"].stringValue)
                        self.errorMsg = getJSON["msg"].stringValue
                        self.showErr.toggle()
                    }
                }
            }
        }
    }
    
}
