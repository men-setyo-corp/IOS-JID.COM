//
//  SetBottomSheet.swift
//  JID.COM
//
//  Created by Macbook on 22/08/22.
//  Ket: Dev Not Use

import SwiftUI

struct SetBottomSheet: View {
    
    var writer: Data_pemeliharaan
    
    var body: some View {
        VStack{
            Capsule()
                .fill(Color(white: 0.75))
                .frame(width: 50, height: 5)
            Text("Pemeliharaan")
                .fontWeight(.bold).padding(.top, 7)
                .foregroundColor(.black)
            Text(writer.ket_status)
                .padding(.bottom, 10)
                .foregroundColor(.black)
            HStack
            {
                Text("Nama Ruas").font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Text(writer.nama_ruas)
                    .foregroundColor(.black)
            }
            HStack
            {
                Text("Nama KM")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Text(writer.km)
                    .foregroundColor(.black)
            }.padding(.top, 2)
            
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 50)
        .padding(.top, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.white)
    }
}

struct SetBottomSheet_Previews: PreviewProvider {
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
        SetBottomSheet(writer: writerPreview)
    }
}
