//
//  ContentView.swift
//  JID.COM
//
//  Created by Macbook on 06/08/22.
//

import SwiftUI
import SwiftyJSON
import Foundation

struct ContentView: View {
    
    @StateObject var modelLogin : LoginModel = LoginModel()
    
    var body: some View {
        NavigationView{
            if modelLogin.isLogin {
                MainPage()
                    .navigationBarHidden(true)
            }else{
                if modelLogin.isLogin {
                    MainPage()
                        .navigationBarHidden(true)
                }else{
                    LoginPage()
                        .navigationBarHidden(true)
                }
            }
        }
        .onAppear{
            if modelLogin.isLogin {
                modelLogin.refresSession(){ success in
                    if success {
                        print("update token")
                    }else{
                        modelLogin.isLogin = false
                    }
                }
            }
            if Dataset.stsInfoJalanTol.isEmpty {
                Dataset.stsInfoJalanTol = ["yes","no","no","no","no","yes","no"]
            }
            if Dataset.stsSisinfokom.isEmpty {
                Dataset.stsSisinfokom = ["no","no","no","no","no","no","no","no","no","no"]
            }
            if Dataset.stsEventTol.isEmpty {
                Dataset.stsEventTol = ["no","no","no"]
            }
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RestData: Codable {
    let resultCount: Int
    let results: [GetDataRes]
}
struct GetDataRes: Codable {
    var version: String
}
