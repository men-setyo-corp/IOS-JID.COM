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
    @AppStorage("auth") var auth: String = ""
    @AppStorage("name") var nama: String = ""
    @AppStorage("scope") var scope: String = ""
    @AppStorage("item") var item: String = ""
    @AppStorage("vip") var vip: Int = 0
    @AppStorage("report") var report: String = ""
    @AppStorage("dashboard") var dashboard: String = ""
    @AppStorage("isLogin") var isLogin: Bool = false
    @AppStorage("fcmToken") var fcmToken: String = ""
    @AppStorage("statusNotif") var statusNotif: Int = 0
    @AppStorage("menuJalantoll") var menuJalantoll: String = ""
    @AppStorage("menuSisinfokom") var menuSisinfokom: String = ""
    @AppStorage("menuEventlalin") var menuEventlalin: String = ""
    
    //mark: auth login
    func PresLogin(paramsData: Parameters, completion: @escaping (Bool) -> (Void)) async throws{
        DispatchQueue.main.async {
            RestApiController().resAPIDev(endPoint: "auth/v1/login",method: .post ,dataParam: paramsData, token:""){ (results) in
                let getJSON = JSON(results ?? "Null data from API")
                if getJSON["status"].boolValue {
                    self.auth = getJSON["token"].stringValue
                    self.addLogSession(){ success in
                        if success {
                            self.nama = getJSON["data"]["name"].stringValue
                            self.scope = getJSON["data"]["scope"].stringValue
                            self.item = getJSON["data"]["item"].stringValue
                            self.report = getJSON["data"]["report"].stringValue
                            self.dashboard = getJSON["data"]["dashboard"].stringValue
                            self.vip = getJSON["data"]["vip"].intValue
                            
                            self.menuJalantoll = getJSON["data"]["infojalantol"].stringValue
                            self.menuSisinfokom = getJSON["data"]["sisinfokom"].stringValue
                            self.menuEventlalin = getJSON["data"]["eventjalantol"].stringValue
                            
                            completion(true)
                        }else{
                            completion(false)
                        }
                    }
                }else{
                    self.errorMsg = getJSON["message"].stringValue
                    self.showErr.toggle()
                    print(getJSON["msg"].stringValue)
                    completion(false)
                }
            }
        }
    }
    
    func addLogSession(completion: @escaping (Bool) -> (Void)){
        let deviceNm = UIDevice.current.name
    
        let parameters : Parameters = ["token_fcm": fcmToken, "device":"mobile", "device_name": deviceNm]
        DispatchQueue.main.async {
            RestApiController().resAPIDev(endPoint: "auth/v1/update-session", method: .patch ,dataParam: parameters, token: self.auth){ results in
                let getJSON = JSON(results ?? "Null data from API")
                let status = getJSON["status"].boolValue
                if status {
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
        self.isLogin = false
//        DispatchQueue.main.async {
//            RestApiController().resAPIDevGet(endPoint: "auth/v1/logout", method: .get){ results in
//                let getJSON = JSON(results ?? "Null data from API")
//                let status = getJSON["status"].boolValue
//                if status {
//                    self.errorMsg = getJSON["message"].stringValue
//                    self.isLogin = false
//                    completion(true)
//                }else{
//                    self.errorMsg = getJSON["message"].stringValue
//                    self.isLogin = true
//                    completion(false)
//                }
//            }
//        }
    }
    
    
}


