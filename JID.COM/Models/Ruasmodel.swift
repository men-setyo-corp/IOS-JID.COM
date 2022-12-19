//
//  Ruasmodel.swift
//  JID.COM
//
//  Created by Macbook on 15/09/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct Getruas: Codable, Identifiable {
    let id: Int
    let id_ruas: Int
    let nama_ruas: String
    let nama_ruas_2: String
}

class Ruasmodel: ObservableObject {
    @Published var showErr: Bool = false
    @Published var errorMsg: String = ""
    
    var modelLogin : LoginModel = LoginModel()
    
    func getRuas(completion: @escaping ([Getruas]) -> ()){
        DispatchQueue.global().async {
            let paramsData: Parameters = ["id_ruas": self.modelLogin.scope]
            RestApiController().resAPI(endPoint: "data_ruas/", method: .put, dataParam: paramsData){ (results) in
                let getJSON = JSON(results ?? "Null data from API")
                DispatchQueue.main.async {
                    if getJSON["status"].intValue == 1 {
                        do {
                            let jsonData = try JSONEncoder().encode(getJSON["results"])
//                            let jsonString = String(data: results!, encoding: .utf8)!
//                            print(jsonString)
                            let decodedSentences = try JSONDecoder().decode([Getruas].self, from: jsonData)
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
