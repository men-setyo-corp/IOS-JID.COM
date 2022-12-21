//
//  ContentView.swift
//  JID.COM
//
//  Created by Macbook on 06/08/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var modelLogin : LoginModel = LoginModel()
    
    
    var body: some View {
        NavigationView{
            if modelLogin.isLogin {
                MainPage()
                    .navigationBarHidden(true)
            }else{
                LoginPage()
                    .navigationBarHidden(true)
            }
        }
        .onAppear{
            if Dataset.stsInfoJalanTol.isEmpty {
                Dataset.stsInfoJalanTol = ["yes","no","no","no","no","yes","no"]
            }
            if Dataset.stsSisinfokom.isEmpty {
                Dataset.stsSisinfokom = ["no","no","no","no","no","no","no","no","no","no","no"]
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
