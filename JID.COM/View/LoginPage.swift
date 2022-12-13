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
                .foregroundColor(Color.blue)
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
                Image("bgTest")
                    .resizable()
                    .aspectRatio(geometry.size, contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Image("logowhite")
                        .resizable()
                        .frame(width: 120, height: 120, alignment: .center)
                        .padding(.bottom, 35)
                    VStack{
                        Text("Hey, \nSilahkan Login")
                            .font(.largeTitle.bold())
                            .foregroundColor(.black)
                            .hLeading()
                        
                        //MARK:test field
                        TextField("Email", text: $modelLogin.email)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, lineWidth: modelLogin.email == "" ? 0: 1)
                            )
                            .background{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.05))
                            }
                            .foregroundColor(Color.black)
                            .textInputAutocapitalization(.never)
                            .padding(.top, 20)
                        SecureTextField(text: $modelLogin.password)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, lineWidth: modelLogin.password == "" ? 0: 1)
                            )
                            .background{
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.05))
                            }
                            .foregroundColor(Color.black)
                            .textInputAutocapitalization(.never)
                            .padding(.top, 15)
                        
                        
                        
                        Button{
                            Task{
                                modelLogin.txtLoging = false
                                let parameters: Parameters = [ "username" : modelLogin.email, "password" : modelLogin.password ]
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
                                            Color.blue.opacity(0.7) : Color.blue)
                                }
                        }
                        .padding(.top, 20)
                        .disabled(modelLogin.email == "" || modelLogin.password == "")
                        .alert(modelLogin.errorMsg ,isPresented: $modelLogin.showErr){
                            //alert in button
                        }
                        
                        NavigationLink("",destination: HomePage()
                                        .navigationBarHidden(true)
                                        .navigationBarBackButtonHidden(true), isActive:self.$isActive)
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    //end vstack
                    
                    
                    NavigationLink {
                        
                    } label: {
                        Text("Jasamarga Integrated Digitalmap")
                            .foregroundColor(.white)
                            .fontWeight(Font.Weight.bold)
                    }
                    .padding(.top, 20)
                }
                .padding()
                // end Vstack
            }
        }
        
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
