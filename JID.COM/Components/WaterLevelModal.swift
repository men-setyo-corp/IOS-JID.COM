//
//  WaterLevelModal.swift
//  JID.COM
//
//  Created by Panda on 18/12/22.
//

import SwiftUI

struct WaterLevelModal: View {
    var writer: Data_water_level
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                VStack{
                    Text("Water Level Sensor")
                        .fontWeight(.bold).padding(.top, 7)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.bottom, 15)
                        .foregroundColor(.black)
            
                }
                VStack{
                    HStack
                    {
                        Text("Data Sensor")
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
                        Text("\(writer.nama_lokasi)")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Nama Ruas")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.nama_ruas)")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Level Sensor")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.level_sensor)")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Detail Sensor")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Level")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.level)")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Hujan")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.hujan)")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Pompa")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.pompa)")
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
                        Text("\(writer.waktu_update)")
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }
                    .padding(.top, 3)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background(Color.white)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}

struct WaterLevelModal_Previews: PreviewProvider {
    static let sendData = Data_water_level(nama_lokasi: "", nama_ruas: "", level_sensor: 0, level: "", hujan: "", pompa: "", waktu_update: "")
    
    static var previews: some View {
        WaterLevelModal(writer: sendData)
    }
}
