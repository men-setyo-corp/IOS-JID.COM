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
    let id: Int
    let camera_id: Int
    let nama: String
    let status : String
    let arteri : Int
    let key_id: String
    let nama_segment: String
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
    
    func getCctv(idruas: Int, idsegment: Int,completion: @escaping ([Getcctv]) -> ()){
        DispatchQueue.global().async {
            let paramsData: Parameters = ["id_ruas": idruas, "id_segment": String(idsegment)]
            RestApiController().resAPI(endPoint: "segment/cctv", method: .put, dataParam: paramsData){ (results) in
                let getJSON = JSON(results ?? "Null data from API")
                DispatchQueue.main.async {
                    if getJSON["status"].intValue == 1 {
                        if getJSON["results"].count > 0 {
                            self.showErr.toggle()
                            do {
                                let jsonData = try JSONEncoder().encode(getJSON["results"])
                                let decodedSentences = try JSONDecoder().decode([Getcctv].self, from: jsonData)
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
    
    func getCctvNonJM(idruas: Int, idsegment: Int,completion: @escaping ([Getcctvsnonjm]) -> ()){
        DispatchQueue.global().async {
            let paramsData: Parameters = ["id_ruas": idruas, "id_segment": String(idsegment)]
            RestApiController().resAPI(endPoint: "segment/cctv", method: .put, dataParam: paramsData){ (results) in
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
            RestApiController().resAPI(endPoint: "data/cctv", method: .put, dataParam: paramsData){ (results) in
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
