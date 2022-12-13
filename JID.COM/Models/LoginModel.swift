//
//  LoginModel.swift
//  JID.COM
//
//  Created by Macbook on 10/08/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import MapboxMaps

class LoginModel: ObservableObject {
  
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var txtLoging: Bool = true
    @Published var showErr: Bool = false
    @Published var showPopup: Bool = false
    @Published var errorMsg: String = ""
    
    //mark: session in local storage
    @AppStorage("name") var nama: String = ""
    @AppStorage("scope") var scope: String = ""
    @AppStorage("item") var item: String = ""
    @AppStorage("vip") var vip: Int = 0
    @AppStorage("report") var report: String = ""
    @AppStorage("dashboard") var dashboard: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    
    //mark: auth login
    func PresLogin(paramsData: Parameters, completion: @escaping (Bool) -> (Void)) async throws{
        DispatchQueue.main.async {
            RestApiController().resAPI(endPoint: "auth_login/", method: .put ,dataParam: paramsData){ (results) in
                let getJSON = JSON(results ?? "Null data from API")
                
                if getJSON["status"].intValue == 1 {
                    self.addLogSession(name: self.nama){ success in
                        if success {
                            //mark: set local storage
                            self.nama = getJSON["data"]["name"].stringValue
                            self.scope = getJSON["data"]["scope"].stringValue
                            self.item = getJSON["data"]["item"].stringValue
                            self.report = getJSON["data"]["report"].stringValue
                            self.dashboard = getJSON["data"]["dashboard"].stringValue
                            self.vip = getJSON["data"]["vip"].intValue
                            
                            completion(true)
                        }else{
                            completion(false)
                        }
                    }
                }else{
                    self.errorMsg = getJSON["msg"].stringValue
                    self.showErr.toggle()
                    print(getJSON["msg"].stringValue)
                    completion(false)
                }
            }
        }
    }
    
    func addLogSession(name: String, completion: @escaping (Bool) -> (Void)){
        let deviceNm = UIDevice.current.name
        let strIPAddress : String = getIP().getIPAddress()
    
        let parameters : Parameters = ["name": name, "device_name":deviceNm, "addr": strIPAddress]
        DispatchQueue.main.async {
            RestApiController().resAPI(endPoint: "add_session_dev/", method: .put ,dataParam: parameters){ results in
                let getJSON = JSON(results ?? "Null data from API")
                let status = getJSON["status"].intValue
                if status == 1 {
                    self.errorMsg = getJSON["msg"].stringValue
                    self.isLogin = true
                    completion(true)
                }else{
                    self.isLogin = false
                    self.errorMsg = getJSON["msg"].stringValue
                    completion(false)
                }
            }
        }
    }
    
    func logoutLogin(completion: @escaping (Bool) -> (Void)){
        let parameters : Parameters = ["name": self.nama]
        DispatchQueue.main.async {
            RestApiController().resAPI(endPoint: "del_session/", method: .put ,dataParam: parameters){ results in
                let getJSON = JSON(results ?? "Null data from API")
                let status = getJSON["status"].intValue
                if status == 1 {
                    self.errorMsg = getJSON["msg"].stringValue
                    self.isLogin = false
                    completion(true)
                }else{
                    self.errorMsg = getJSON["msg"].stringValue
                    self.isLogin = true
                    completion(false)
                }
            }
        }
    }
    
    
}


