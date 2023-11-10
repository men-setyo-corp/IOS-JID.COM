//
//  MainPage.swift
//  JID.COM
//
//  Created by Macbook on 13/09/22.
//

import SwiftUI

struct MainPage: View {
    @StateObject var modelLogin : LoginModel = LoginModel()
    
    init(){
        UITabBar.appearance().barTintColor = .systemBackground
    }
    @State var selectedIndex = 0
    let tabbarImgaeName = ["house", "play.tv.fill", "map.fill", "bookmark.circle.fill", "stopwatch.fill"]
    let tabNameMenu = ["Home", "CCTV", "Map", "Antrian", "Realtime"]
    
    @State var showTopMenuBar = true
    @State var showAlertLogout = false
    @State var showProgresLoading = false
    
    var body: some View {
        VStack{
            if showTopMenuBar {
                ZStack{
                    HStack{
                        Text(modelLogin.nama.prefix(1).uppercased())
                          .padding()
                          .background(Color(UIColor(hexString: "#DFEFFF")))
                          .clipShape(Circle())
                          .foregroundColor(Color(UIColor(hexString: "#390099")))
                          .font(.system(size: 19, weight: .bold))
                        
                        
                        VStack(alignment: .leading){
                            Text("Halo")
                                .foregroundColor(.init(white:0.7))
                                .font(.system(size: 15))
                            Text(modelLogin.nama)
                                .foregroundColor(Color(UIColor(hexString: "#390099")))
                                .font(.system(size: 17))
                        }
                        Spacer()
                        HStack(alignment: .center){
                            NavigationLink(
                                destination: HistoriNotif(),
                            label:{
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(LoginModel().statusNotif == 1 ? Color.red : Color(UIColor(hexString: "#390099")))
                            })
                            .padding(7)
                            .background(Color(UIColor(hexString: "#DFEFFF")))
                            .clipShape(Circle())
//                            Button{
//                                print("Notification pressed")
//                            } label:{
//                                Image(systemName: "bell.fill")
//                                    .font(.system(size: 18, weight: .bold))
//                                    .foregroundColor(Color(UIColor(hexString: "#390099")))
//                            }
//                            .padding(7)
//                            .background(Color(UIColor(hexString: "#DFEFFF")))
//                            .clipShape(Circle())
                            
                            Button{
                                showAlertLogout = true
                            } label:{
                                Image(systemName: "power")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(UIColor(hexString: "#390099")))
                            }
                            .alert("Peringatan Akun", isPresented: $showAlertLogout) {
                                Button {
                                    // nothing needed here
                                } label: {
                                    Text("Tidak")
                                        .bold()
                                        .tint(.purple)
                                }
                                .tint(.purple)
                                Button {
                                    self.showProgresLoading = true
                                    modelLogin.logoutLogin(){ success in
                                        if success {
                                            modelLogin.isLogin = false
                                            self.showProgresLoading = false
                                        }else{
                                            modelLogin.isLogin = true
                                            self.showProgresLoading = false
                                            modelLogin.showErr.toggle()
                                        }
                                    }
                                } label: {
                                    Text("Yakin")
                                        .foregroundColor(.red)
                                }.alert(modelLogin.errorMsg ,isPresented: $modelLogin.showErr){
                                    //alert in button
                                }
                            } message: {
                                Text("Apakah anda yakin ingin keluar dari akun anda ?")
                            }
                            .padding(7)
                            .background(Color(UIColor(hexString: "#DFEFFF")))
                            .clipShape(Circle())
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            //set content menu
            ZStack{
                if showProgresLoading {
                    ProgressView("Loading...")
                        .tint(Color(UIColor(hexString: "#00448C")))
                        .foregroundColor(.black)
                        .zIndex(2)
                    Rectangle()
                        .fill(.white.opacity(0.65))
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .zIndex(1)
                    
                }
                switch selectedIndex{
                case 0 :
                    HomePage()
                case 1:
                    CctvPage()
                case 2:
                    MapPage(showCarousel: false, idruas: 0, stopRun: false)
                case 3:
                    AntrianPage()
                case 4:
                    RealtimePage()
                default:
                    NavigationView{
                        Text("Home Main")
                    }.foregroundColor(.white)
                }
            }
            
            //end set content menu
            
            Spacer()
            HStack{
                ForEach(0..<5){ num in
                    Button {
                        selectedIndex = num
                        if num == 2 {
                            showTopMenuBar = false
                        }else{
                            showTopMenuBar = true
                        }
                    } label: {
                        Spacer()
                        VStack{
                            Image(systemName: tabbarImgaeName[num])
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(selectedIndex == num ? Color(UIColor(hexString: "#390099")) : .init(white: 0.6))
                            Text(tabNameMenu[num])
                                .padding(.top,2)
                                .font(.system(size:12))
                                .foregroundColor(selectedIndex == num ? Color(UIColor(hexString: "#390099")) : .init(white: 0.6))
                        }
                        Spacer()
                    }
                }
                
            }
        }
        .background(Color(.white))
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
