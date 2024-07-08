//
//  MainPage.swift
//  JID.COM
//
//  Created by Macbook on 13/09/22.
//

import SwiftUI
import Alamofire

struct MainPage: View {
    @StateObject var modelLogin : LoginModel = LoginModel()
    
    init(){
        UITabBar.appearance().barTintColor = .systemBackground
    }
    @State var selectedIndex = 0
    let tabbarImgaeName = ["menu_home", "menu_cctv", "menu_map", "menu_perjam", "menu_realtime"]
    let tabbarImgaeNamewarna = ["menu_home_warna", "menu_cctv_warna", "menu_map_warna", "menu_perjam_warna", "menu_realtime_warna"]
//    let tabNameMenu = ["Home", "CCTV", "Map", "Antrian", "Realtime"]
    let tabNameMenu = ["Home", "CCTV", "Map", "Lalin", "Realtime"]
    
    @State var showTopMenuBar = true
    @State var showAlertLogout = false
    @State var showProgresLoading = false
    @State private var showUpdate = false
    
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
                            .alert("Logout", isPresented: $showAlertLogout) {
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
                        .onAppear{
                            cekUpdateApp()
                        }
                case 1:
                    CctvPage()
                        .onAppear{
                            cekUpdateApp()
                        }
                case 2:
                    MapPage(showCarousel: false, idruas: 0, stopRun: false)
                        .onAppear{
                            cekUpdateApp()
                        }
                case 3:
                    AntrianPage()
                        .onAppear{
                            cekUpdateApp()
                        }
                case 4:
                    RealtimePage()
                        .onAppear{
                            cekUpdateApp()
                        }
                default:
                    NavigationView{
                        Text("Home Main")
                    }
                    .foregroundColor(.white)
                    .onAppear{
                        cekUpdateApp()
                    }
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
                            Image(selectedIndex == num ? tabbarImgaeNamewarna[num] : tabbarImgaeName[num])
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
        .alert("Update Versi JID Moible", isPresented: $showUpdate) {
            Button {
                if let url = URL(string: "itms-apps://itunes.apple.com/app/6444597322"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
//                    exit(1)
                }
            } label: {
                Text("Update")
                    .foregroundColor(.red)
            }
        } message: {
            Text("Silahkan Melakukan Update Versi Terbaru JID Mobile !")
        }
    }
    
    func cekUpdateApp(){
        let currentAppVersion = Bundle.main.infoDictionary
        AF.request("http://itunes.apple.com/jp/lookup/?id=6444597322",
                   method: .get,
                   parameters: nil,
                   headers: nil)
        .responseDecodable(of: RestData.self){ response in
            switch response.result {
            case .success(let data):
                let curVer = currentAppVersion?["CFBundleShortVersionString"] as! String
                let lastVer = data.results[0].version
                if lastVer != curVer {
                    showUpdate = true
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
    }
}
