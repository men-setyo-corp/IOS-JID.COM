//
//  SpeedModal.swift
//  JID.COM
//
//  Created by Panda on 17/12/22.
//

import SwiftUI

struct SpeedModal: View {
    var writer: Data_speed
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                VStack{
                    Text("Speed Camp")
                        .fontWeight(.bold).padding(.top, 7)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.bottom, 1)
                        .foregroundColor(.black)
                    Text("\(writer.cabang), \(writer.nama_lokasi)")
                        .font(.system(size: 14, weight: .bold))
                        .padding(.bottom, 1)
                        .foregroundColor(.black)
                    Text("(\(writer.posisi))")
                        .font(.system(size: 14, weight: .bold))
                        .padding(.bottom, 15)
                        .foregroundColor(.black)
                }
                VStack{
                    HStack
                    {
                        Text("Kecepatan")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                    }
                    HStack
                    {
                        Text("0 - 40")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.kec_1)")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("40 - 80")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.kec_2)")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("80 >")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.kec_3)")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    
                    Divider()
                     .frame(height: 1)
                     .padding(.horizontal, 10)
                     .background(Color(UIColor(hexString: "#DFEFFF")))
                    
                    HStack{
                        Text("Total")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                        Text("\(writer.total_volume)")
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }
                    .padding(.top, 3)
                    HStack{
                        Text("Last Update")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                        Text(writer.waktu_update)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }
                    .padding(.top, 3)
                    
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background(Color.white)
            
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}

struct SpeedModal_Previews: PreviewProvider {
    static let sendData = Data_speed(camera_id: 0, nama_lokasi: "", cabang: "", posisi: "", kec_1: 0, kec_2: 0, kec_3: 0, total_volume: 0, waktu_update: "")
    
    static var previews: some View {
        SpeedModal(writer: sendData)
    }
}
