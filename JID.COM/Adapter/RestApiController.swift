//
//  RestApiController.swift
//  JID.COM
//
//  Created by Macbook on 10/08/22.
//

import SwiftUI
import MapboxMaps
import Alamofire

class RestApiController{
    
    public let url_based = "https://jid.jasamarga.com/client-api/"
//    public let url_based_dev = "https://jid.jasamarga.com/t3s/"
    public let url_based_dev = "http://20.10.20.185:10010/"
    
    let headers: HTTPHeaders? = ["Content-Type": "application/json",
                                 "Authorization": "2345391662"]
    
    @AppStorage("status_login") var isLoging: Bool = false
    var modelLogin : LoginModel = LoginModel()
    
    struct responseAPI: Codable {
        let msg: String
        let status: Int
        let data : JSONObject
    }
    
    struct responseAPILine: Codable {
        let msg: String
        let status: Int
        let linedata : JSONObject
    }
    
    func getAPI(from url: String,completion: @escaping (_ data: JSONObject?) -> ()) {
        
        let urlset = URL(string: url_based+url)!
        var request = URLRequest(url: urlset)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2345391662", forHTTPHeaderField: "Authorization")
        
        if url == "showlalin" || url == "data/jalan_penghubung" || url == "data/pompa" || url == "data/bike" || url == "data/midas" {
            request.httpMethod = "GET"
        }else{
            let json: [String: Any] = ["id_ruas": modelLogin.scope]
            let params = try? JSONSerialization.data(withJSONObject: json)
            request.httpMethod = "POST"
            request.httpBody = params
        }
        
        let task = URLSession.shared.dataTask(with: (request), completionHandler: { getdata, response, error in
            guard let getdata = getdata, error == nil else{
                print("something went wrong of get data form api")
                return
            }
            var result: responseAPI?
            do{
                result = try JSONDecoder().decode(responseAPI.self, from: getdata)
            }catch{
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else{
                return
            }
            completion(json.data)
            
        })
        task.resume()
    }
    
    func getAPILine(from url: String,completion: @escaping (_ data: JSONObject?) -> ()) {
        
        let urlset = URL(string: url_based+url)!
        var request = URLRequest(url: urlset)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2345391662", forHTTPHeaderField: "Authorization")
        
        let json: [String: Any] = ["id_ruas": modelLogin.scope]
        let params = try? JSONSerialization.data(withJSONObject: json)
        request.httpMethod = "POST"
        request.httpBody = params
        
        let task = URLSession.shared.dataTask(with: (request), completionHandler: { getdata, response, error in
            guard let getdata = getdata, error == nil else{
                print("something went wrong of get data form api")
                return
            }
            var result: responseAPILine?
            do{
                result = try JSONDecoder().decode(responseAPILine.self, from: getdata)
            }catch{
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else{
                return
            }
            completion(json.linedata)
            
        })
        task.resume()
    }
    
    func resAPI(endPoint: String, method: HTTPMethod, dataParam: Parameters, completion: @escaping (_ data: Data?) -> ()) {
        AF.request(self.url_based+endPoint,
            method: method,
            parameters: dataParam,
            encoding: JSONEncoding.default,
            headers: self.headers)
        .responseData { dataResponse in
            switch dataResponse.result
            {
                case .success(let json):
                    completion(json)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func resAPIDev(endPoint: String, method: HTTPMethod, dataParam: Parameters, token: String, completion: @escaping (_ data: Data?) -> ()) {
        let headersdev: HTTPHeaders? = ["Authorization": "Bearer "+modelLogin.auth]
        AF.request(self.url_based_dev+endPoint,
            method: method,
            parameters: dataParam,
            encoding: JSONEncoding.default,
            headers: headersdev)
        .responseData { dataResponse in
            switch dataResponse.result
            {
                case .success(let json):
                    completion(json)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func resAPIDevGet(endPoint: String, method: HTTPMethod, completion: @escaping (_ data: Data?) -> ()) {
        let headersdev: HTTPHeaders? = ["Authorization": "Bearer "+modelLogin.auth]
        print(modelLogin.auth)
        print(self.url_based_dev+endPoint)
        AF.request(self.url_based_dev+endPoint,
            method: method,
            encoding: JSONEncoding.default,
            headers: headersdev)
        .responseData { dataResponse in
            switch dataResponse.result
            {
                case .success(let json):
                    completion(json)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    
    
}
