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
    
    public let url_based = "https://api-provider-jid.jasamarga.com/" //client-api/
//    public let url_based_dev = "https://jid.jasamarga.com/t3s/"
    public let url_based_dev = "https://api-provider-jid.jasamarga.com/"
    
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
        request.setValue("Bearer "+modelLogin.auth, forHTTPHeaderField: "Authorization")
        
        if url == "client-api/showlalin" || url == "client-api/data/jalan_penghubung" || url == "client-api/data/pompa" || url == "client-api/data/bike" || url == "client-api/data/midas" {
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
        request.setValue("Bearer "+modelLogin.auth, forHTTPHeaderField: "Authorization")
        
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
        let headers: HTTPHeaders? = ["Authorization": "Bearer "+modelLogin.auth]
       
        AF.request(self.url_based+endPoint,
            method: method,
            parameters: dataParam,
            encoding: JSONEncoding.default,
            headers: headers)
        .responseData { dataResponse in
            switch dataResponse.result
            {
                case .success(let json):
                    completion(json)
                case .failure(let error):
                    if endPoint == "auth/v2/login" {
                        print(error)
                        self.modelLogin.txtLoging = false
                        self.modelLogin.showErr = true
                        self.modelLogin.errorMsg = "Could not connect to the server."
                    }
            }
        }
    }
    func resAPIGet(endPoint: String, method: HTTPMethod, completion: @escaping (_ data: Data?) -> ()) {
        let headers: HTTPHeaders? = ["Authorization": "Bearer "+modelLogin.auth]
//        print("Bearer "+modelLogin.auth)
//        print(self.url_based+endPoint)
        AF.request(self.url_based+endPoint,
            method: method,
            encoding: JSONEncoding.default,
            headers: headers)
        .responseData { dataResponse in
            switch dataResponse.result
            {
                case .success(let json):
                    completion(json)
                case .failure(let error):
                    print(error)
                    if endPoint == "auth/v1/refresh-session" {
                        self.modelLogin.isLogin = false
                    }
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
