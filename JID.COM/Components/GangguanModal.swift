//
//  GangguanModal.swift
//  JID.COM
//
//  Created by Panda on 15/12/22.
//

import SwiftUI

struct GangguanModal: View {
    var writer: Data_gangguan
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                VStack{
                    Text("Gangguan Lalin")
                        .fontWeight(.bold).padding(.top, 7)
                        .font(.system(size: 14))
                        .padding(.bottom, 1)
                        .foregroundColor(.black)
                    Text(writer.ket_status != "" ? writer.ket_status : "Status Gangguan")
                        .padding(.bottom, 20)
                        .padding(.top, 1)
                        .foregroundColor(.black)
                        .font(.system(size: 13, weight: .bold))
                }
                VStack{
                    HStack
                    {
                        Text("Nama Ruas")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                        Text(writer.nama_ruas)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }
                    HStack
                    {
                        Text("Nama KM")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.km)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Jalur / Lajur")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.jalur+"/"+writer.lajur)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Waktu Kejadian")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.waktu_kejadian)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Waktu Selesai")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.waktu_selsai == "" ? "-" : writer.waktu_selsai)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Jenis Gangguan")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.ket_tipe_gangguan)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Detail Gangguan")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                    }.padding(.top, 3)
                    Divider()
                     .frame(height: 1)
                     .padding(.horizontal, 10)
                     .background(Color(UIColor(hexString: "#DFEFFF")))
                    HStack{
                        Text(writer.detail_kejadian != "" ? writer.detail_kejadian : "-")
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                            .multilineTextAlignment(.leading)
                        Spacer()
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

struct GangguanModal_Previews: PreviewProvider {
    static let writerPreview = Data_gangguan(title: "", idx: 0, id_ruas: 0, ket_status: "", nama_ruas: "", km: "", jalur: "", lajur: "", ket_tipe_gangguan: "", waktu_kejadian: "", detail_kejadian: "", dampak: "", waktu_selsai: "")
    
    static var previews: some View {
        GangguanModal(writer: writerPreview)
    }
}
