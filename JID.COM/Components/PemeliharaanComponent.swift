//
//  PemeliharaanComponent.swift
//  JID.COM
//
//  Created by Macbook on 29/08/22.
//

import SwiftUI

struct PemeliharaanComponent: View {
    var writer: Data_pemeliharaan
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                VStack{
                    Text("Pemeliharaan")
                        .fontWeight(.bold).padding(.top, 7)
                        .font(.system(size: 14))
                        .padding(.bottom, 1)
                        .foregroundColor(.black)
                    Text(writer.ket_status != "" ? writer.ket_status : "Status Pemeliharaan")
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
                        Text("Range KM")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.range_km_pekerjaan)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Waktu Awal")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.waktu_awal)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Waktu Akhir")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.waktu_akhir)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Kegiatan")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.ket_jenis_kegiatan)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Detail Keterangan")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                    }.padding(.top, 3)
                    Divider()
                     .frame(height: 1)
                     .padding(.horizontal, 10)
                     .background(Color(UIColor(hexString: "#DFEFFF")))
                    HStack{
                        Text(writer.keterangan_detail != "" ? writer.keterangan_detail : "-")
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.top, 3)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background(Color.white)
        }
        .background(Color.white)
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}

struct PemeliharaanComponent_Previews: PreviewProvider {
    static let writerPreview = Data_pemeliharaan(
        title: "",
        idx: 0,
        id_ruas: 0,
        ket_status: "",
        nama_ruas: "",
        km: "",
        jalur: "",
        lajur: "",
        range_km_pekerjaan: "",
        waktu_awal: "",
        waktu_akhir: "",
        ket_jenis_kegiatan: "",
        keterangan_detail: ""
    )
    
    static var previews: some View {
        PemeliharaanComponent(writer: writerPreview)
    }
}
