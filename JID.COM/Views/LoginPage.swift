//
//  LoginPage.swift
//  JID.COM
//
//  Created by Macbook on 10/08/22.
//

import SwiftUI
import Alamofire
import UIKit

struct SecureTextField: View{
    
    @State private var isSecureField : Bool = true
    
    @Binding var text : String
    
    var body: some View{
        HStack{
            if isSecureField {
                SecureField("Password", text: $text)
            }else{
                TextField(text, text: $text)
            }
        }.overlay(alignment: .trailing){
            Image(systemName: isSecureField ? "eye.slash" : "eye")
                .onTapGesture {
                    isSecureField.toggle()
                }
                .foregroundColor(Color(UIColor(hexString: "#00448C")))
        }
    }
}

struct LoginPage: View {
    
    @StateObject var modelLogin : LoginModel = LoginModel()
    @State var navigated = false
    @State private var isActive: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                Color.white
                    .ignoresSafeArea()
                Ellipse()
                    .fill(Color(UIColor(hexString: "#00448C")))
                    .frame(width: geometry.size.width * 2.10, height: geometry.size.height * 1)
                    .position(x: geometry.size.width / 2.0)
                    .shadow(radius: 3)
                    .edgesIgnoringSafeArea(.all)
                
                ZStack{
                    Ellipse()
                        .fill(Color.white)
                        .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.17)
                        .position(x: geometry.size.width / 2.3, y: geometry.size.height / 4.3)
                        .zIndex(0.1)
                    Image("logonew")
                        .resizable()
                        .frame(width: geometry.size.width * 0.23, height: geometry.size.height * 0.1)
                        .position(x: geometry.size.width / 2.3, y: geometry.size.height / 4.3)
                        .zIndex(1)
                        .shadow(color: .black.opacity(0.30), radius: 20)
                    
                    VStack{
                        Text("Welcome back!")
                            .font(.system(size: 17))
                            .foregroundColor(Color(UIColor(hexString: "#00448C")))
                            .hLeading()
                            .padding(.top, 70)
                        //MARK:test field
                        Text("Username")
                            .font(.system(size: 13))
                            .padding(.top, 10)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TextField("Username", text: $modelLogin.email)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: modelLogin.email == "" ? 0: 1)
                            )
                            .background{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.05))
                            }
                            .font(.system(size: 13))
                            .textInputAutocapitalization(.never)
                            .foregroundColor(.black)
                        
                        Text("Password")
                            .font(.system(size: 13))
                            .padding(.top, 15)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        SecureTextField(text: $modelLogin.password)
                            .foregroundColor(.black)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, lineWidth: modelLogin.password == "" ? 0: 1)
                            )
                            .background{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.05))
                            }
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                            .textInputAutocapitalization(.never)
        
                        
                        Button{
                            Task{
                                modelLogin.txtLoging = false
                                let parameters: Parameters = [ "user" : modelLogin.email, "pass" : modelLogin.password, "token_fcm": modelLogin.fcmToken ]
                                do{
                                    try await modelLogin.PresLogin(paramsData: parameters){ success in
                                        modelLogin.txtLoging.toggle()
                                        if success {
                                            isActive = true
                                        }else{
                                            isActive = false
                                        }
                                    }
                                }catch{
                                    modelLogin.errorMsg = error.localizedDescription
                                    modelLogin.showErr.toggle()
                                }
                            }
                        } label: {
                            Text(modelLogin.txtLoging ? "Login" : "Loading...")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding()
                                .hCenter()
                                .background{
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(modelLogin.email == "" || modelLogin.password == "" ?
                                              Color(UIColor(hexString: "#00448C")).opacity(0.7) : Color(UIColor(hexString: "#00448C")))
                                }
                                .font(.system(size: 13))
                        }
                        .padding(.top, 20)
                        .disabled(modelLogin.email == "" || modelLogin.password == "")
                        .alert(modelLogin.errorMsg ,isPresented: $modelLogin.showErr){
                            //alert in button
                        }
                      
//                        NavigationLink("",destination: MainPage()
//                                        .navigationBarHidden(true)
//                                        .navigationBarBackButtonHidden(true), isActive:self.$isActive)
                        
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.30), radius: 20)
                    //end vstack
                    
                    
                    NavigationLink {
                        
                    } label: {
                        Text("©Copyright 2018 - 2024 Jasa Marga")
                            .foregroundColor(Color(UIColor(hexString: "#828282")))
                            .font(.system(size: 12))
                    }
                    .frame(alignment: .center)
                    .position(x: geometry.size.width / 2.2, y: geometry.size.height / 1.1)
                    
                    Text("versi 1.3.3")
                        .font(.system(size: 12))
                        .frame(alignment: .center)
                        .position(x: geometry.size.width / 2.2, y: geometry.size.height / 1.1)
                        .foregroundColor(Color(UIColor(hexString: "#828282")))
                        .padding(.top, 20)
                        .zIndex(1)
                }
                .padding(25)
                
                // end Vstack
            }
            .background(.white)
        }
        .edgesIgnoringSafeArea(.all)
        
    }
    
}


struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}

//MARK : Extention UI
extension View{
    func hLeading()->some View{
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    func hTrailing()->some View{
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    func hCenter()->some View{
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    func fullBackground(imageName: String) -> some View {
       return background(
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea(.all)
       )
    }
    
}
