//
//  MenuDashboard.swift
//  JID.COM
//
//  Created by Macbook on 21/09/22.
//

import SwiftUI

struct MenuDashboard: View {
    @StateObject var modelLogin : LoginModel = LoginModel()
    
    @State var aktiveClick: Bool = false
    @State var selectedIndex = 0
    let tabTopBarName = ["Lalu Lintas","Pemeliharaan", "Peralatan"]
    let tabMidleBarName = ["Dashboard\nLalu Lintas", "Realtime\nTraffic", "Antrian\nGerbang", "Lalin\nPer Jam"]
    let tabBottomBarName = ["Gangguan\nLalu Lintas"]
    
    let tabMidleBarIcon = ["dashboardsvg", "reltraf", "antger", "lalperjam"]
    let tabPemeliharaanIcon = ["dash", "pemeli", "wate"]
    let tabBottomBarIcon = ["dashboardsvg", "motalat", "relcctv", "reldms"]
    
    let tabGangguanIcon = ["datgang"]
    
//    old
//    let setMenu = ["dashboard_lalin/mobile", "realtime_lalin/mobile", "antrian_gerbang/mobile", "lalin_perjam/mobile"]
//    let menuGangguan = ["data_gangguan/mobile"]
//    let menuPemeliharaan = ["dashboard_pemeliharaan/mobile", "data_pemeliharaan/mobile", "water_level_sensor/mobile"]
//    let menuPeralatan = ["dashboard/mobile", "preview_dashboard/mobile", "realtime_peralatan_cctv", "realtime_peralatan_vms"]
    
//    new
    let menuLaluLintas = ["Dashboard Lalin", "Realtime Lalin", "Antrian Gerbang", "Lalin Perjam", "Data Gangguan"]
    let menuPemeliharaan = ["Dashboard Pemeliharaan", "Data Pemeliharaan", "Water Level Sensor"]
    let menuPeralatan = ["Dashboard Peralatan", "Monitoring Alat", "Realtime CCTV", "Realtime VMS"]
    
    
    //pemeliharaan menu
    let tabPemeliharaaanBarName = ["Dashboard\nPemeliharaan", "Data\nPemeliharaan", "Water\nLevel Sensor"]
    
    //Peralatan
    let tabPeralatanBarName = ["Dashboard\nPeralatan", "Monitoring\nAlat", "Realtime\nCCTV", "Realtime\nDMS"]
    
    @State var tabArryData = ["Dashboard\nLalu Lintas", "Realtime\nTraffic", "Antrian\nGerbang", "Lalin\nPer Jam"];
    @State var tabArryUrl = ["Dashboard Lalin", "Realtime Lalin", "Antrian Gerbang", "Lalin Perjam", "Data Gangguan"];
    @State var tabArryIcon = ["dashboardsvg", "reltraf", "antger", "lalperjam"];
    
    var urlweb: String = ""
    @State var isShowBottomMenu: Bool = true
    
    var body: some View {
        VStack{
            HStack{
                ForEach(0..<tabTopBarName.count, id: \.self){ num in
                    Spacer()
                    Button{
                        selectedIndex = num
                        // 0 = tab menu lalu lintas
                        // 1 = tab menu pemeliharaan
                        // 2 = tab menu peralatan
                        if num == 0 {
                            tabArryData = tabMidleBarName
                            tabArryUrl = menuLaluLintas
                            tabArryIcon = tabMidleBarIcon
                            isShowBottomMenu = true
                        }else if num == 1 {
                            tabArryData = tabPemeliharaaanBarName
                            tabArryUrl = menuPemeliharaan
                            tabArryIcon = tabPemeliharaanIcon
                            isShowBottomMenu = false
                        }else if num == 2 {
                            tabArryData = tabPeralatanBarName
                            tabArryUrl = menuPeralatan
                            tabArryIcon = tabBottomBarIcon
                            isShowBottomMenu = false
                        }
                    }label:{
                        Text(tabTopBarName[num])
                            .padding(5)
                            .padding(.horizontal, 10)
                            .font(.system(size: 12))
                            .foregroundColor(selectedIndex == num ? Color(UIColor(hexString: "#390099")) : Color(UIColor(hexString: "#818181")))
                            
                    }
                    .background(selectedIndex == num ? Color(UIColor(hexString: "#DFEFFF")) : Color(.white))
                    .cornerRadius(10)
                    Spacer()
                }
                
            }
            .padding(.bottom, 13)
            
            HStack(alignment: .center, spacing: 0){
                ForEach(0..<tabArryData.count,id: \.self){ num in
                    Spacer()
                    VStack{
                        NavigationLink(
                            destination: MainDashboard(title: tabArryData[num], menu: tabArryUrl, index: num, parentmenu: selectedIndex),
                        label:{
                            Image(tabArryIcon[num])
                                .font(.system(size: 17))
                                .foregroundColor(Color(UIColor(hexString: "#390099")))
                        })
                        .padding(20)
                        .background(Color(UIColor(hexString: "#DFEFFF")))
                        .clipShape(Circle())
                        Text(tabArryData[num])
                            .font(.system(size:12))
                            .scaledToFit()
                            .foregroundColor(Color(UIColor(hexString: "#390099")))
                            .multilineTextAlignment(.center)
                    }.frame(alignment: .center)
                    Spacer()
                }
            }
         
            if isShowBottomMenu == true {
                HStack(alignment: .center, spacing: 0){
                    ForEach(0..<1){ num in
                        VStack{
                            NavigationLink(
                                destination: MainDashboard(title: tabBottomBarName[num], menu: menuLaluLintas, index: 4, parentmenu: selectedIndex),
                            label:{
                                Image(tabGangguanIcon[num])
                                    .font(.system(size: 17))
                                    .foregroundColor(Color(UIColor(hexString: "#390099")))
                            })
                            .padding(20)
                            .background(Color(UIColor(hexString: "#DFEFFF")))
                            .clipShape(Circle())
                            Text(tabBottomBarName[num])
                                .font(.system(size:12))
                                .scaledToFit()
                                .foregroundColor(Color(UIColor(hexString: "#390099")))
                                .multilineTextAlignment(.center)
                        }.frame(alignment: .center)
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
            }
            

            Spacer()
        }
        .padding(.top, 20)
        
    }
}

struct MenuDashboard_Previews: PreviewProvider {
    static var previews: some View {
        MenuDashboard()
    }
}
