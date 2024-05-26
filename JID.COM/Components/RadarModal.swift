//
//  RadarModal.swift
//  JID.COM
//
//  Created by Panda on 17/12/22.
//

import SwiftUI

struct RadarModal: View {
    var writer: Data_radar
    
    var body: some View {
        NavigationView{
            Color.white
                .ignoresSafeArea(.all)
                .overlay{
                    ZStack(alignment: .bottom){
                        VStack{
                            VStack{
                                Text("Monitoring Traffic (Radar)")
                                    .fontWeight(.bold).padding(.top, 7)
                                    .font(.system(size: 14))
                                    .padding(.bottom, 15)
                                    .foregroundColor(.black)
                            }
                            VStack{
                                HStack
                                {
                                    Text("Data Radar")
                                        .foregroundColor(.black)
                                        .font(.system(size: 13, weight: .bold))
                                    Spacer()
                                }
                                HStack
                                {
                                    Text("Nama Lokasi")
                                        .font(.system(size: 13))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text(writer.nama_lokasi)
                                        .foregroundColor(.black)
                                        .font(.system(size: 13, weight: .bold))
                                }.padding(.top, 3)
                                HStack
                                {
                                    Text("VCR Jalur A")
                                        .font(.system(size: 13))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text(String(format: "%.2f", writer.vcr_jalur_a))
                                        .foregroundColor(.black)
                                        .font(.system(size: 13, weight: .bold))
                                }.padding(.top, 3)
                                HStack
                                {
                                    Text("VCR Jalur B")
                                        .font(.system(size: 13))
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text(String(format: "%.2f", writer.vcr_jalur_b))
                                        .foregroundColor(.black)
                                        .font(.system(size: 13, weight: .bold))
                                }.padding(.top, 3)
                                
                                Divider()
                                 .frame(height: 1)
                                 .padding(.horizontal, 10)
                                 .background(Color(UIColor(hexString: "#DFEFFF")))
                                HStack{
                                    Text("Last Update")
                                        .foregroundColor(.black)
                                        .font(.system(size: 13, weight: .bold))
                                    Spacer()
                                    Text(writer.last_update)
                                        .foregroundColor(.black)
                                        .font(.system(size: 13))
                                }
                                .padding(.top, 3)
                                HStack{
                                    Spacer()
                                    NavigationLink(
                                        destination: WebviewDashboard(urlweb: writer.url_radar, title: "Dashboard Radar"),
                                    label:{
                                        Text("LIHAT DATA")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color(UIColor(hexString: "#344879")))
                                            .padding(10)
                                    })
                                    .background(Color(UIColor(hexString: "#DFEFFF")))
                                    .cornerRadius(5)
                                }
                                .padding(.top, 3)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .background(Color.white)
                    }
                    .background(Color.red)
                    .frame(maxWidth: .infinity, alignment: .bottom)
                }
            
        }
        .padding(.vertical)
        
    }
}

struct RadarModal_Previews: PreviewProvider {
    static let sendData = Data_radar(idx: 0, id_ruas: 0, nama_lokasi: "", vcr_jalur_a: 0, vcr_jalur_b: 0, last_update: "", url_radar: "")
    
    static var previews: some View {
        RadarModal(writer: sendData)
    }
}
