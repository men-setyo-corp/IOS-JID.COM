//
//  DataGangguan.swift
//  JID.COM
//
//  Created by Panda on 15/11/23.
//

import SwiftUI

struct DataGangguan: View {
    @State var dataGangguan : [InitDataGangguan] = []
    @State var search = ""
    @State var showDetail : Bool = false
    @State var namaRuas = ""
    @State var jenis = ""
    @State var waktu = ""
    @State var selesai = ""
    @State var detail = ""
    @State var dampak = ""
    
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
                    if dataGangguan.isEmpty {
                        ProgressView()
                    }else{
                        Text("Data Gangguan Lalin Kosong !")
                    }
                }else{
                    ScrollView{
                        ForEach(searchResults) { gangguan in
                            Button{
                                showDetail = true
                                namaRuas = gangguan.nama_ruas
                                jenis = gangguan.ket_tipe_gangguan
                                waktu = gangguan.waktu_kejadian
                                selesai = gangguan.waktu_selesai ?? "-"
                                detail = gangguan.detail_kejadian
                                dampak = gangguan.dampak
                            }label:{
                                VStack(alignment:.leading){
                                    HStack{
                                        Text(gangguan.nama_ruas)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color.black)
                                        Spacer()
                                        Text(gangguan.ket_status)
                                            .padding(5)
                                            .padding(.horizontal, 5)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.white)
                                            .background(gangguan.id_status == 3 ? Color(UIColor(hexString: "#0e6efd")) : gangguan.id_status == 1 ? Color(UIColor(hexString: "#dc3545")) : Color(UIColor(hexString: "#ffc107")))
                                            .cornerRadius(5)
                                    }
                                    Text(gangguan.ket_tipe_gangguan)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Color.black)
                                    HStack{
                                        Text(gangguan.km)
                                            .padding(5)
                                            .padding(.horizontal, 5)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.white)
                                            .background(Color(UIColor(hexString: "#6d757d")))
                                            .cornerRadius(5)
                                        Text(gangguan.jalur)
                                            .padding(5)
                                            .padding(.horizontal, 5)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.white)
                                            .background(Color(UIColor(hexString: "#6d757d")))
                                            .cornerRadius(5)
                                        Text(gangguan.lajur)
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
                        Text("Jenis")
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                        Text(jenis)
                            .font(.system(size: 13))
                    }
                    Divider()
                    HStack{
                        Text("Waktu Kejadian")
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                        Text(Dataset().convertDateFormat(inputDate: waktu))
                            .font(.system(size: 13))
                    }
                    Divider()
                    HStack{
                        Text("Waktu Selesai")
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                        Text(selesai == "-" ? "-" : Dataset().convertDateFormat(inputDate: selesai))
                            .font(.system(size: 13))
                    }
                    Divider()
                    HStack{
                        Text("Dampak")
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                        Text(dampak)
                            .font(.system(size: 13))
                    }
                    
                    Text("Detail Kejadian")
                        .font(.system(size: 13, weight: .bold))
                        .padding(.top, 5)
                    Text(detail)
                        .font(.system(size: 13))
                        .padding(.top, 1)
                }
                .padding(.top, 15)
                .padding(.horizontal)
                .presentationDetents([.medium, .large, .height(250)])
            }
        }
        .onAppear{
            GangguanLalinModel().getListDataGangguan{ (datares) in
                dataGangguan = datares
                namaRuas = datares[0].nama_ruas
                jenis = datares[0].ket_tipe_gangguan
                waktu = datares[0].waktu_kejadian
                selesai = datares[0].waktu_selesai ?? "-"
                detail = datares[0].detail_kejadian
                dampak = datares[0].dampak
            }
        }
    }
    
    var searchResults: [InitDataGangguan] {
        if search.isEmpty {
            return self.dataGangguan
        } else {
            return self.dataGangguan.filter { $0.nama_ruas.localizedStandardContains(search) }
        }
    }
    
}

struct DataGangguan_Previews: PreviewProvider {
    static var previews: some View {
        DataGangguan()
    }
}
