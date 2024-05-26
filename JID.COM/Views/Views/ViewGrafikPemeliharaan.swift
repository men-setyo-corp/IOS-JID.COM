//
//  ViewGrafikPemeliharaan.swift
//  JID.COM
//
//  Created by Panda on 04/10/23.
//

import SwiftUI
import Charts

struct ViewGrafikPemeliharaan: View {
    @ObservedObject var dataGrafik = GrafikPemeliharaan()
    @State var filterPemeliShow = false
    @State var btnHarian = false
    @State var btnBulanan = true
    @State var btnReginal = false
    
    var options = ["Januari", "Febuari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"]
    var reginal = ["All", "Metropolitan", "Transjawa", "Nusantara"]
    
    var bulan =  Calendar.current.component(.month, from: Date())
    
    @State private var selectedOptionDari = ""
    @State private var selectedOptionSampai = ""
    @State private var selectedRegional = 0
    
    @State private var waktuDari = ""
    @State var search = ""
    @State var dataruas : [GetRuasApi] = []
    @State var ruasSelect = "All"
    @State var idruas = 0
    @State var placeholderRuas = "Cari ruas"
    
    var body: some View {
        let setBulanAwal = bulan - 1
        let setBulanAkhir = Int(bulan) - 5
        let dataPemeli = [
            (kategori: "Proses", data: dataGrafik.SetDataProses),
            (kategori: "Selesai", data: dataGrafik.SetDataSelesai)
        ]
        
        GroupBox (label:
            HStack{
            Text("Grafik Pemeliharaan")
                .foregroundColor(Color(UIColor(hexString: "#390099")))
                .font(.system(size: 14))
                Spacer()
            Button{
                filterPemeliShow = true
            }label:{
                HStack{
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 12))
                    Text("Filter")
                        .font(.system(size: 12))
                        .foregroundColor(Color(UIColor(hexString: "#390099")))
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                
            }
            .background(Color(UIColor(hexString: "#FFFFFF")))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(UIColor(hexString: "#DADADA")), lineWidth: 1)
            )
            .sheet(isPresented: $filterPemeliShow){
                VStack(alignment: .leading){
                    HStack{
                        Spacer()
                        Capsule()
                            .frame(width: 40, height: 6)
                            .background(Color(UIColor(hexString: "#C2C2C2")))
                            .cornerRadius(10)
                        Spacer()
                    }
                    
                    HStack{
                        Text("Filter")
                            .font(.system(size: 14))
                        Spacer()
                        Text("Reset")
                            .font(.system(size: 14))
                            .foregroundColor(Color(UIColor(hexString: "#113399")))
                    }
                    Text("Rentan Laporan")
                        .font(.system(size: 14, weight: .bold))
                        .padding(.top, 10)
                    HStack{
                        // Harian
                        Button{
                            btnBulanan = false
                            btnHarian = true
                        }label:{
                            Text("Harian")
                                .font(.system(size: 14))
                                .foregroundColor(btnHarian ? Color(UIColor(hexString: "#0D68F9")) : Color(UIColor(hexString: "#C2C2C2")))
                                .padding()
                        }
                        .background(Color(UIColor(hexString: "#FFFFFF")))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(btnHarian ? Color(UIColor(hexString: "#0D68F9")) : Color(UIColor(hexString: "#DADADA")), lineWidth: 1)
                        )
                        // Bulanan
                        Button{
                            btnHarian = false
                            btnBulanan = true
                            waktuDari = selectedOptionDari
                        }label:{
                            Text("Bulanan")
                                .font(.system(size: 14))
                                .foregroundColor(btnBulanan ? Color(UIColor(hexString: "#0D68F9")) : Color(UIColor(hexString: "#C2C2C2")))
                                .padding()
                        }
                        .background(Color(UIColor(hexString: "#FFFFFF")))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(btnBulanan ? Color(UIColor(hexString: "#0D68F9")) : Color(UIColor(hexString: "#DADADA")), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                    Text(btnHarian ? "Tanggal" : "Bulan")
                        .font(.system(size: 14, weight: .bold))
                        .padding(.top, 15)
                    HStack{
                        Picker("Dari", selection: $selectedOptionDari) {
                            ForEach(options, id: \.self) {
                                Text($0)
                                    .font(.system(size: 13, weight: .bold))
                            }
                        }
                        .pickerStyle(.menu)
                        .onAppear{
                            selectedOptionDari = options[setBulanAkhir]
                        }
                        Spacer()
                        Text("S/D")
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                        Picker("Sampai", selection: $selectedOptionSampai) {
                            ForEach(options, id: \.self) {
                                Text($0)
                                    .font(.system(size: 13, weight: .bold))
                            }
                        }
                        .pickerStyle(.menu)
                        .onAppear{
                            selectedOptionSampai = options[setBulanAwal]
                        }
                    }
                    Text("Regional")
                        .font(.system(size: 14, weight: .bold))
                        .padding(.top, 15)
                    HStack(alignment: .center, spacing:10){
                        ForEach(0..<reginal.count, id: \.self){ dataNum in
                            Button{
                                selectedRegional = dataNum
                            }label:{
                                Text(reginal[dataNum])
                                    .font(.system(size: 13))
                                    .foregroundColor(selectedRegional == dataNum ? Color(UIColor(hexString: "#0D68F9")) : Color(UIColor(hexString: "#C2C2C2")))
                                    .padding()
                            }
                            .background(Color(UIColor(hexString: "#FFFFFF")))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedRegional == dataNum ? Color(UIColor(hexString: "#0D68F9")) : Color(UIColor(hexString: "#DADADA")), lineWidth: 1)
                            )
                        }
                    }
                    
                    Text("Ruas")
                        .font(.system(size: 14, weight: .bold))
                        .padding(.top, 15)
                    VStack{
                        TextField(placeholderRuas, text: $search)
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
                                    Spacer()
                                    Text(ruasSelect)
                                        .font(.system(size: 13))
                                        .padding(.trailing, 10)
                                }
                            )
                            .padding(.bottom, 10)
                            .searchable(text: $search)
                        ScrollView{
                            ForEach(searchResults) { ruasVal in
                                VStack(alignment: .leading){
                                    Button{
                                        search.removeAll()
                                        ruasSelect = ruasVal.nama_ruas
                                        placeholderRuas = "Ruas"
                                        idruas = ruasVal.id_ruas
                                    }label:{
                                        Text(ruasVal.nama_ruas)
                                            .font(.system(size: 13))
                                            .foregroundColor(Color(UIColor(hexString: "#000000")))
                                    }
                                    
                                    Divider()
                                        .frame(height: 1)
                                        .background(Color(UIColor(hexString: "#C2C2C2")))
                                }
                                .padding(.bottom, 10)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical)
                        .background(Color(UIColor(hexString: "#C2C2C2")))
                        .cornerRadius(10)
                        .onAppear{
                            Ruasmodel().getRuasApi{ (parsedata) in
                                self.dataruas = parsedata
                            }
                        }
                        
                        VStack{
                            Button{
                                dataGrafik.setParmsRuas = "\(idruas)"
                                dataGrafik.setParmsDari = "2023-\(setBulanAkhir)"
                                dataGrafik.setParmsSampai = "2023-\(setBulanAwal)"
                                dataGrafik.GetDataDashPemiServer()
                                filterPemeliShow = false
                            }label:{
                                Text("Terapkan")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(UIColor(hexString: "#FFFFFF")))
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(Color(UIColor(hexString: "#113399")))
                            .cornerRadius(10)
                            
                        }
                        .padding(.vertical)
                    }
                    
                }
                .padding(.vertical)
                .padding(.horizontal)
                .presentationDetents([.large, .large])
                
            }
            
        }) {
            Chart(dataPemeli, id:\.kategori){ step in
                ForEach(step.data) { setdata in
                    BarMark(
                        x: .value("Bulan", setdata.bulan),
                        y: .value("Value", setdata.kategori)
                    )
                    .position(by: .value("Jenis", step.kategori))
                    .foregroundStyle(by: .value("Jenis", step.kategori))
                    .cornerRadius(10.0)
                    .annotation {
                        Text("\(setdata.kategori)")
                            .font(.system(size: 10))
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartForegroundStyleScale([
//                "Dalam Rencana" : Color(.systemBlue),
                "Proses": Color(.systemOrange),
                "Selesai": Color(.systemGreen)
            ])
            .chartLegend(spacing: 10)
            .padding(.vertical)
        }
        .backgroundStyle(Color(UIColor(hexString: "#BFD7FF")))
        .frame(height:350)
        .onAppear{
            dataGrafik.setParmsRuas = "5"
            dataGrafik.setParmsDari = "2023-\(setBulanAkhir)"
            dataGrafik.setParmsSampai = "2023-\(setBulanAwal)"
            dataGrafik.GetDataDashPemiServer()
        }
    }
    
    var searchResults: [GetRuasApi] {
        if search.isEmpty {
            return self.dataruas
        } else {
            return self.dataruas.filter { $0.nama_ruas.localizedStandardContains(search) }
        }
    }
    
}

struct ViewGrafikPemeliharaan_Previews: PreviewProvider {
    static var previews: some View {
        ViewGrafikPemeliharaan()
    }
}
