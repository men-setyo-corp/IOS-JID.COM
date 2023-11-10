//
//  MainDashboard.swift
//  JID.COM
//
//  Created by Panda on 19/09/23.
//

import SwiftUI

struct MainDashboard: View {
    @StateObject var modelLogin : LoginModel = LoginModel()
    @Environment(\.presentationMode) var presentationMode
    
    @State var title : String
    @State var menu : [String]
    @State var index : Int
    @State var parentmenu : Int
    
    @State var showTopMenuBar = true
    @State var showAlertLogout = false
    @State var showProgresLoading = false
    @State var selectedIndex = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack{
                    HStack{
                        Button{
                            self.presentationMode.wrappedValue.dismiss()
                        }label:{
                            Text(Image(systemName: "chevron.backward"))
                                .foregroundColor(Color.white)
                                .font(.system(size: 20, weight: .bold))
                        }
                        Spacer()
                        
                        Text(title == "" ? "Dashboard Title": title.replacingOccurrences(of: "\n", with: " "))
                            .foregroundColor(Color.white)
                            .font(.system(size: 17, weight: .bold))
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
                    .padding(.horizontal, 25)
                    .padding(.bottom, 15)
                    Spacer()
                    
                    VStack(alignment: .leading){
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(0..<menu.count,id: \.self){ num in
                                    Button{
                                        selectedIndex = num
                                    }label:{
                                        Text(menu[num])
                                            .padding(5)
                                            .padding(.horizontal, 5)
                                            .font(.system(size: 12))
                                            .foregroundColor(selectedIndex == num ? Color(UIColor(hexString: "#390099")) : Color(UIColor(hexString: "#818181")))
                                            
                                    }
                                    .background(selectedIndex == num ? Color(UIColor(hexString: "#DFEFFF")) : Color(.white))
                                    .cornerRadius(10)
                                }
                            }
                            Spacer()
                        }
                        
                    }
                    .padding(.vertical)
                    .padding(.horizontal)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
                    .background(Color.white)
                    .clipShape(RoundedCorners(radius: 25, corners: [.topLeft, .topRight]))
                    
                }
                
                VStack{
                    // 0 = tab menu lalu lintas
                    // 1 = tab menu pemeliharaan
                    // 2 = tab menu peralatan
                    if parentmenu == 0 {
                        switch selectedIndex{
                        case 0 :
                            DashLaluLintas()
                        default:
                            NavigationView{
                                Text("Home Main")
                            }.foregroundColor(.white)
                        }
                    }else if parentmenu == 1 {
                        switch selectedIndex{
                        case 0 :
                            DashboardPemeliharaan()
                        case 1:
                            DataPemeliharaan()
                        case 2:
                            WaterLevelSensor()
                        default:
                            NavigationView{
                                Text("Home Main")
                            }.foregroundColor(.white)
                        }
                    }else if parentmenu == 2 {
                        switch selectedIndex{
                        case 0 :
                            DashboardPemeliharaan()
                        default:
                            NavigationView{
                                Text("Home Main")
                            }.foregroundColor(.white)
                        }
                    }
                    
                }
                .padding(.top, 110)
            }
            .navigationBarHidden(true)
            .background(Color(UIColor(hexString: "#390099")))
            .onAppear{
                selectedIndex = index
                if menu.count == 0 {
                    menu = ["Data Dashboard 1", "Data Dashboard 2", "Data Dashboard 2"]
                }
            }
        }
    }
}

struct MainDashboard_Previews: PreviewProvider {
    static var previews: some View {
        MainDashboard(title: "", menu: [], index: 0, parentmenu: 0)
    }
}

struct RoundedCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        return Path(path.cgPath)
    }
}
