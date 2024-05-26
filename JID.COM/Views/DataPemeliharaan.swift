//
//  DataPemeliharaan.swift
//  JID.COM
//
//  Created by Panda on 20/09/23.
//
import SwiftUI

struct DataPemeliharaan: View {
    @State var dataPemeliharaan : [InitDataPemeliharaan] = []
    @State var search = ""
    @State var showDetail : Bool = false
    @State var namaRuas : String = ""
    @State var range : String = ""
    @State var kegiatan : String = ""
    @State var awal: String = ""
    @State var akhir: String = ""
    @State var keterangan : String = ""
    
    var body: some View {
        ZStack{
            VStack{
                TextField("Nama Ruas", text: $search)
                    .padding(10)
                    .padding(.horizontal, 25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                    )
                    .background{
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.05))
                    }
                    .foregroundColor(.gray)
                    .textInputAutocapitalization(.never)
                    .font(.system(size: 13))
                    .overlay(
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 10)
                                .font(.system(size: 13))
                        }
                    )
                    .searchable(text: $search)
                Spacer()
                
                if searchResults.isEmpty {
                    if dataPemeliharaan.isEmpty {
                        ProgressView()
                    }else{
                        Text("Data Pemeliharaan Kosong !")
                    }
                }else{
                    ScrollView{
                        ForEach(searchResults, id: \.idx) { pemeliharaan in
                            Button{
                                showDetail = true
                                namaRuas = pemeliharaan.nama_ruas
                                range = pemeliharaan.range_km_pekerjaan
                                kegiatan = pemeliharaan.ket_jenis_kegiatan
                                awal = pemeliharaan.waktu_awal
                                akhir = pemeliharaan.waktu_akhir ?? ""
                                keterangan = pemeliharaan.keterangan_detail
                            }label:{
                                VStack(alignment:.leading){
                                    HStack{
                                        Text(pemeliharaan.nama_ruas)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color.black)
                                        Spacer()
                                        Text(pemeliharaan.ket_status)
                                            .padding(5)
                                            .padding(.horizontal, 5)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.white)
                                            .background(pemeliharaan.id_status == 3 ? Color(UIColor(hexString: "#0e6efd")) : pemeliharaan.id_status == 1 ? Color(UIColor(hexString: "#dc3545")) : Color(UIColor(hexString: "#ffc107")))
                                            .cornerRadius(5)
                                    }
                                    Text(pemeliharaan.ket_jenis_kegiatan)
                                        .font(.system(size: 14, weight: .bold ))
                                        .foregroundColor(Color.black)
                                    HStack{
                                        Text(pemeliharaan.km)
                                            .padding(5)
                                            .padding(.horizontal, 5)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.white)
                                            .background(Color(UIColor(hexString: "#6d757d")))
                                            .cornerRadius(5)
                                        Text(pemeliharaan.jalur)
                                            .padding(5)
                                            .padding(.horizontal, 5)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.white)
                                            .background(Color(UIColor(hexString: "#6d757d")))
                                            .cornerRadius(5)
                                        Text(pemeliharaan.lajur)
                                            .padding(5)
                                            .padding(.horizontal, 5)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.white)
                                            .background(Color(UIColor(hexString: "#6d757d")))
                                            .cornerRadius(5)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                )
                                .background{
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.08))
                                }
                                .cornerRadius(16)
                                .padding(.top, 10)
                                .shadow(radius: 5)
                                
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            
        }
        .onAppear{
            PemeliharaanModel().getListDataPemeliharaan{ (datares) in
                dataPemeliharaan = datares
                namaRuas = datares[0].nama_ruas
                range = datares[0].range_km_pekerjaan
                kegiatan = datares[0].ket_jenis_kegiatan
                awal = datares[0].waktu_awal
                akhir = datares[0].waktu_akhir ?? ""
                keterangan = datares[0].keterangan_detail
            }
        }
        .sheet(isPresented: $showDetail){
            VStack(alignment: .leading){
                HStack{
                    Spacer()
                    Text(namaRuas)
                        .font(.system(size: 14, weight: .bold))
                    Spacer()
                }
                .padding(.bottom, 5)
                HStack{
                    Text("Range")
                        .font(.system(size: 13, weight: .bold))
                    Spacer()
                    Text(range)
                        .font(.system(size: 13))
                }
                Divider()
                HStack{
                    Text("Kegiatan")
                        .font(.system(size: 13, weight: .bold))
                    Spacer()
                    Text(kegiatan)
                        .font(.system(size: 13))
                }
                Divider()
                HStack{
                    Text("Waktu Awal")
                        .font(.system(size: 13, weight: .bold))
                    Spacer()
                    Text(awal == "" ? "-" : Dataset().convertDateFormat(inputDate: awal))
                        .font(.system(size: 13))
                }
                Divider()
                HStack{
                    Text("Waktu Akhir")
                        .font(.system(size: 13, weight: .bold))
                    Spacer()
                    Text(akhir != "" ? Dataset().convertDateFormat(inputDate: akhir) : "-")
                        .font(.system(size: 13))
                }
                
                Text("Keterangan")
                    .font(.system(size: 13, weight: .bold))
                    .padding(.top, 5)
                Text(keterangan)
                    .font(.system(size: 13))
                    .padding(.top, 1)
            }
            .padding(.top, 15)
            .padding(.horizontal)
            .presentationDetents([.medium, .large, .height(250)])
        }
    }
    
    var searchResults: [InitDataPemeliharaan] {
        if search.isEmpty {
            return self.dataPemeliharaan
        } else {
            return self.dataPemeliharaan.filter { $0.nama_ruas.localizedStandardContains(search) }
        }
    }
}

struct DataPemeliharaan_Previews: PreviewProvider {
    static var previews: some View {
        DataPemeliharaan()
    }
}

