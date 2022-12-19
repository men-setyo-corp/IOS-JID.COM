//
//  KejadianLalin.swift
//  JID.COM
//
//  Created by Macbook on 21/09/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct Kejadian: Codable, Identifiable {
    let idx : Int
    let nama_ruas: String
    let nama_ruas_2: String
    let km: String
    let arah_jalur: String
    let dampak: String
    let waktu: String
    let jenis_event: String
    let ket_status: String
    let jalur: String
    let lajur: String
    let ket: String
    let range_km:  String
    let waktu_end:  String
    
    var id : Int {idx}
}

class KejadianLalin: ObservableObject {
    @Published var showErr: Bool = false
    @Published var errorMsg: String = ""
    
    var modelLogin : LoginModel = LoginModel()
    
    func getKejadianLalin(tipe_lalin: String, completion: @escaping ([Kejadian]) -> ()){
        DispatchQueue.global().async {
            let paramsData: Parameters = ["id_ruas": self.modelLogin.scope]
            RestApiController().resAPI(endPoint: "kejadian_lalin_by_ruas/", method: .post ,dataParam: paramsData){ (results) in
                let getJSON = JSON(results ?? "Null data from API")
                DispatchQueue.main.async {
                    if getJSON["status"].intValue == 1 {
                        var dataResult:JSON = [];
                        do {
                            if tipe_lalin == "gangguan" {
                                dataResult = getJSON["results"]["gangguan_lalin"]
                            }else if tipe_lalin == "rekayasa"{
                                dataResult = getJSON["results"]["rekayasa_lalin"]
                            }else if tipe_lalin == "pemeliharaan" {
                                dataResult = getJSON["results"]["pemeliharaan"]
                            }
                            let jsonData = try JSONEncoder().encode(dataResult)
                            let decodedSentences = try JSONDecoder().decode([Kejadian].self, from: jsonData)
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
