//
//  RtmsModal.swift
//  JID.COM
//
//  Created by Panda on 17/12/22.
//

import SwiftUI

struct RtmsModal: View {
    var writer: Data_rtms
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                VStack{
                    Text("Traffic Counting (RTMS)")
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .padding(.bottom, 1)
                        .foregroundColor(.black)
                    Text(writer.nama_lokasi)
                        .padding(.bottom, 20)
                        .padding(.top, 1)
                        .foregroundColor(.black)
                        .font(.system(size: 13, weight: .bold))
                }
                VStack{
                    HStack
                    {
                        Text("Volume Kendaraan")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                    }
                    HStack
                    {
                        Text("Jalur A")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(String(format: "%.2f", writer.total_volume_jalur_a))
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                   
                    HStack
                    {
                        Text("Jalur B")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(String(format: "%.2f", writer.total_volume_jalur_b))
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Kecapatan Rata-rata")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Jalur A")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(String(format: "%.2f", writer.speed_jalur_a))
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Jalur B")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(String(format: "%.2f", writer.speed_jalur_b))
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    
                    Divider()
                     .frame(height: 1)
                     .padding(.horizontal, 10)
                     .background(Color(UIColor(hexString: "#DFEFFF")))
                    
                    HStack
                    {
                        Text("Status")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.status == 1 ? "ON" : "OFF")
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Last Update")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.waktu_update)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    
                }
            }
            .padding(.horizontal, 20)
            .background(Color.white)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}

struct RtmsModal_Previews: PreviewProvider {
    static let writerPreview = Data_rtms(id_ruas: 0, title: "", nama_lokasi: "", total_volume_jalur_a: 0, speed_jalur_a: 0, total_volume_jalur_b: 0, speed_jalur_b: 0, status: 0, waktu_update: "")
    
    static var previews: some View {
        RtmsModal(writer: writerPreview)
    }
}
