//
//  DashLaluLintas.swift
//  JID.COM
//
//  Created by Panda on 20/09/23.
//

import SwiftUI
import SwiftyJSON

struct DashLaluLintas: View {
    private let data: [Int] = Array(1...3)
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var dataRekayasa : JSON = []
    @State var dataGangguan : JSON = []
    // Data Rekayasa
    @State var oneway: String = "0"
    @State var contraflow: String = "0"
    @State var pengalihan: String = "0"
    
    // Data Gangguan
    @State var kerjaan_jalan: String = "0"
    @State var kecelakaan: String = "0"
    @State var gangguan_lalin: String = "0"
    @State var penyekatan: String = "0"
    @State var genangan: String = "0"
    @State var lain_lain: String = "0"
    
    @State var selectHari: Bool = true
    @State var selectTahun: Bool = false
    @State var selectDefault: String = "hari"
    
    @State var dateNow: String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Filter")
                    .font(.system(size: 13))
                    .foregroundColor(.black)
                Spacer()
                HStack{
                    Button{
                        selectTahun = true
                        selectHari = false
                        selectDefault = "tahun"
                        //set data rek
                        oneway = dataRekayasa["tahun"]["one_way"].stringValue
                        contraflow = dataRekayasa["tahun"]["contra_flow"].stringValue
                        pengalihan = dataRekayasa["tahun"]["pengalihan"].stringValue
                        //set data gangguan
                        kerjaan_jalan = dataGangguan["tahun"]["kerjaan_jalan"].stringValue
                        kecelakaan = dataGangguan["tahun"]["kecelakaan"].stringValue
                        gangguan_lalin = dataGangguan["tahun"]["gangguan_lalin"].stringValue
                        penyekatan = dataGangguan["tahun"]["penyekatan"].stringValue
                        genangan = dataGangguan["tahun"]["genangan"].stringValue
                        lain_lain = dataGangguan["tahun"]["lain_lain"].stringValue
                        
                    }label:{
                        Image(systemName: selectTahun ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 20))
                            .foregroundColor(selectTahun ? Color.blue : Color.gray)
                    }
                    Text("Tahun")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.black)
                    
                    Button{
                        selectTahun = false
                        selectHari = true
                        selectDefault = "hari"
                        //set data rek
                        oneway = dataRekayasa["hari"]["one_way_daily"].stringValue
                        contraflow = dataRekayasa["hari"]["contra_flow_daily"].stringValue
                        pengalihan = dataRekayasa["hari"]["pengalihan_daily"].stringValue
                        
                        //set data gangguan
                        kerjaan_jalan = dataGangguan["hari"]["kerjaan_jalan_daily"].stringValue
                        kecelakaan = dataGangguan["hari"]["kecelakaan_daily"].stringValue
                        gangguan_lalin = dataGangguan["hari"]["gangguan_lalin_daily"].stringValue
                        penyekatan = dataGangguan["hari"]["penyekatan_daily"].stringValue
                        genangan = dataGangguan["hari"]["genangan_daily"].stringValue
                        lain_lain = dataGangguan["hari"]["lain_lain_daily"].stringValue
                        
                    }label:{
                        Image(systemName: selectHari ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 20))
                            .foregroundColor(selectHari ? Color.blue : Color.gray)
                    }
                    Text("Hari")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.black)
                }
            }
            Text("Dashboard Rekayasa Lalu Lintas")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 15)
                .padding(.bottom, 10)
            
            LazyVGrid(columns: columns, spacing: 20) {
                VStack(alignment: .leading){
                    HStack{
                        Image("oneway")
                            .font(.system(size: 25))
                        Text(oneway)
                            .font(.system(size: 20))
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    Text("One Way")
                        .font(.system(size: 13, weight: .bold))
                        .padding(.top, 5)
                        .foregroundColor(Color.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor(hexString: "#008D39")))
                .cornerRadius(10)
                .shadow(radius: 5)
                
                VStack(alignment: .leading){
                    HStack{
                        Image("contraflow")
                            .font(.system(size: 25))
                        Text(contraflow)
                            .font(.system(size: 20))
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    Text("Contra-Flow")
                        .font(.system(size: 13, weight: .bold))
                        .padding(.top, 5)
                        .foregroundColor(Color.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor(hexString: "#6D51CC")))
                .cornerRadius(10)
                .shadow(radius: 5)
               
                VStack(alignment: .leading){
                    HStack{
                        Image("pengalihan")
                            .font(.system(size: 25))
                        Text(pengalihan)
                            .font(.system(size: 20))
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    Text("Pengalihan")
                        .font(.system(size: 13, weight: .bold))
                        .padding(.top, 5)
                        .foregroundColor(Color.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor(hexString: "#FF5400")))
                .cornerRadius(10)
                .shadow(radius: 5)
                
            }
            
            Text("Last update \(dateNow == "" ? "2023-11-16 13:37:30" : dateNow)")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.black)
                .padding(.top, 5)
                .padding(.bottom, 2)
            
            Text("Dashboard Gangguan Lalu Lintas")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.black)
                .padding(.top, 15)
                .padding(.bottom, 10)
            
            LazyVGrid(columns: columns, spacing: 20){
                ForEach(1..<7){ index in
                    VStack{
                        Image(index == 1 ? "pekerjaan_jalan" :
                                index == 2 ? "kecelakaan" :
                                index == 3 ? "gangguan_lalin" :
                                index == 4 ? "genangan1" :
                                index == 5 ? "pengalihan_arus" : "lainnya")
                        Spacer()
                        Text(index == 1 ? kerjaan_jalan :
                                index == 2 ? kecelakaan :
                                index == 3 ? gangguan_lalin :
                                index == 4 ? genangan :
                                index == 5 ? pengalihan : lain_lain)
                            .font(.system(size: 20))
                            .foregroundColor(Color.black)
                        Spacer()
                        Text(index == 1 ? "Pekerjaan Jalan" :
                                index == 2 ? "Kecelakaan\n" :
                                index == 3 ? "Gangguan Lalin" :
                                index == 4 ? "Genangan\n" :
                                index == 5 ? "Pengalihan Arus" : "Lain-lain\n")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 13, weight: .bold))
                            .padding(.top, 5)
                            .foregroundColor(Color.black)
                    }
                    .padding()
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.gray, lineWidth: 2)
                    )
                    .background{
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(UIColor(hexString: "#E8F3FF")))
                    }
                    .cornerRadius(16)
                }
            }
            Text("Last update \(dateNow == "" ? "2023-11-16 13:37:30" : dateNow)")
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.black)
                .padding(.top, 5)
                .padding(.bottom, 2)
            Spacer()
        }
        .padding()
        .onAppear{
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = df.string(from: date)
            dateNow = dateString
            print(dateString)
            DashboardLalinModel().getDataDashRekayasa{ restRekaysa in
                dataRekayasa = restRekaysa
                
                oneway = dataRekayasa["hari"]["one_way_daily"].stringValue
                contraflow = dataRekayasa["hari"]["contra_flow_daily"].stringValue
                pengalihan = dataRekayasa["hari"]["pengalihan_daily"].stringValue
            }
            
            DashboardLalinModel().getDataDashGangguan{ restGangguan in
                dataGangguan = restGangguan
                
                kerjaan_jalan = dataGangguan["hari"]["kerjaan_jalan_daily"].stringValue
                kecelakaan = dataGangguan["hari"]["kecelakaan_daily"].stringValue
                gangguan_lalin = dataGangguan["hari"]["gangguan_lalin_daily"].stringValue
                penyekatan = dataGangguan["hari"]["penyekatan_daily"].stringValue
                genangan = dataGangguan["hari"]["genangan_daily"].stringValue
                lain_lain = dataGangguan["hari"]["lain_lain_daily"].stringValue
            }
            
        }
    }
}

struct DashLaluLintas_Previews: PreviewProvider {
    static var previews: some View {
        DashLaluLintas()
    }
}
