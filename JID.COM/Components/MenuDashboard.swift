//
//  MenuDashboard.swift
//  JID.COM
//
//  Created by Macbook on 21/09/22.
//

import SwiftUI

struct MenuDashboard: View {
    
    @State var aktiveClick: Bool = false
    @State var selectedIndex = 0
    let tabTopBarName = ["Lalu Lintas", "Pemeliharaan", "Peralatan"]
    let tabMidleBarName = ["Dashboard\nLalu Lintas", "Realtime\nTraffic", "Antrian\nGerbang", "Lalin\nPer Jam"]
    let tabMidleBarIcon = ["car.circle.fill", "clock.circle.fill", "waveform.circle.fill", "clock.fill"]
    let tabBottomBarName = ["Gangguan\nLalu Lintas"]
    let tabBottomBarIcon = ["car.circle.fill", "clock.circle.fill", "waveform.circle.fill", "ellipsis.circle.fill"]
    let tabGangguanIcon = ["exclamationmark.circle.fill"]
    let setMenu = ["dashboard_lalin/mobile", "realtime_lalin/mobile", "antrian_gerbang/mobile", "lalin_perjam/mobile"]
    let menuGangguan = ["data_gangguan/mobile"]
    let menuPemeliharaan = ["dashboard_pemeliharaan/mobile", "data_pemeliharaan/mobile", "water_level_sensor/mobile"]
    let menuPeralatan = ["dashboard/mobile", "preview_dashboard/mobile", "realtime_peralatan_cctv", "realtime_peralatan_vms"]
    
    //pemeliharaan menu
    let tabPemeliharaaanBarName = ["Dashboard\nPemeliharaan", "Data\nPemeliharaan", "Water\nLevel Sensor"]
    
    //Peralatan
    let tabPeralatanBarName = ["Dashboard\nPeralatan", "Monitoring\nAlat", "Realtime\nCCTV", "Realtime\nVMS"]
    
    @State var tabArryData = ["Dashboard\nLalu Lintas", "Realtime\nTraffic", "Antrian\nGerbang", "Lalin\nPer Jam"];
    @State var tabArryUrl = ["dashboard_lalin/mobile", "realtime_lalin/mobile", "antrian_gerbang/mobile", "lalin_perjam/mobile"];
    
    var urlweb: String = ""
    @State var isShowBottomMenu: Bool = true
    
    var body: some View {
        VStack{
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    Spacer()
                    ForEach(0..<3){ num in
                        Button{
                            selectedIndex = num
                            if num == 0 {
                                tabArryData = tabMidleBarName
                                tabArryUrl = setMenu
                                isShowBottomMenu = true
                            }else if num == 1 {
                                tabArryData = tabPemeliharaaanBarName
                                tabArryUrl = menuPemeliharaan
                                isShowBottomMenu = false
                            }else if num == 2 {
                                tabArryData = tabPeralatanBarName
                                tabArryUrl = menuPeralatan
                                isShowBottomMenu = false
                            }
                        }label:{
                            Text(tabTopBarName[num])
                                .padding(5)
                                .padding(.horizontal, 15)
                                .font(.system(size: 12))
                                .foregroundColor(selectedIndex == num ? Color(UIColor(hexString: "#390099")) : Color(UIColor(hexString: "#818181")))
                                
                        }
                        .background(selectedIndex == num ? Color(UIColor(hexString: "#DFEFFF")) : Color(.white))
                        .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(.bottom, 13)
            }
            
            HStack{
                ForEach(0..<tabArryData.count,id: \.self){ num in
                    Spacer()
                    VStack{
                        NavigationLink(
                            destination: WebviewDashboard(urlweb: tabArryUrl[num], title: tabArryData[num]),
                        label:{
                            Image(systemName: tabMidleBarIcon[num])
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(UIColor(hexString: "#390099")))
                        })
                        .padding(15)
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
                HStack{
                    ForEach(0..<1){ num in
                        VStack{
                            NavigationLink(
                                destination: WebviewDashboard(urlweb: menuGangguan[num], title: tabBottomBarName[num]),
                            label:{
                                Image(systemName: tabGangguanIcon[num])
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(UIColor(hexString: "#390099")))
                            })
                            .padding(15)
                            .background(Color(UIColor(hexString: "#DFEFFF")))
                            .clipShape(Circle())
                            Text(tabBottomBarName[num])
                                .font(.system(size:12))
                                .scaledToFit()
                                .foregroundColor(Color(UIColor(hexString: "#390099")))
                        }.frame(alignment: .center)
                        Spacer()
                    }
                }
                .padding(.horizontal, 15)
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
