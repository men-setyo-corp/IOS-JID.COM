//
//  WaterLevelSensor.swift
//  JID.COM
//
//  Created by Panda on 03/11/23.
//

import SwiftUI
import SwiftyJSON

struct WaterLevelSensor: View {
    @State var dataWaterLevel : [InitDataWL] = []
    @State var dataRuas : [initRuas] = []
    @State private var selectedOptionWL = "Pilih Ruas"
    @State var search = ""
    @State var searchWl = ""
    @State var ruasSelect = "All"
    @State var idSelect = 0
    @State var filterRuas = false
    @State var colorWater = "#000000"
    
    var body: some View {
        ZStack{
            VStack{
                TextField(" Ruas", text: $searchWl)
                    .tint(Color.white.opacity(0.8))
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
                    .onTapGesture{
                        filterRuas = true
                    }
                    .sheet(isPresented: $filterRuas){
                        VStack(alignment: .leading){
                            TextField("Cari ruas", text: $search)
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
                                .font(.system(size: 17))
                                .overlay(
                                    HStack{
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.gray)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 10)
                                            .font(.system(size: 16))
                                    }
                                )
                                .padding(.top, 10)
                                .padding(.bottom, 10)
                                .searchable(text: $search)
                            ScrollView{
                                ForEach(searchResults) { Rua in
                                    VStack(alignment: .leading){
                                        Button{
                                            ruasSelect = Rua.nama_ruas
                                            WaterLevelModel().getWaterLevelSensor(idruas: Rua.ruas_id){ (parsedata)  in
                                                dataWaterLevel = parsedata
//                                                filterRuas = false
                                                search.removeAll()
                                            }
                                        }label:{
                                            Text(Rua.nama_ruas)
                                                .font(.system(size: 13))
                                                .foregroundColor(Color.black)
                                        }
                                        Divider()
                                            .frame(height: 1)
                                            .background(Color(UIColor(hexString: "#C2C2C2")))
                                    }
                                    .padding(5)
                                }
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal)
                        .presentationDetents([.medium, .large])
                        
                    }
                
                ScrollView{
                    if dataWaterLevel.isEmpty {
//                        ZStack{
//                            Image("Cloudy")
//                                .resizable()
//                                .frame(height:233)
//                                .cornerRadius(10)
//                                .shadow(radius: 2)
//
//                            VStack{
//                                Text("Data Kosong")
//                                    .font(.system(size: 13, weight: .bold))
//                                    .foregroundColor(Color.red)
//                            }
//                            .padding()
//                        }
                        
                    }else{
                        ForEach(dataWaterLevel) { dataVal in
                            ZStack{
                                Image("Cloudy")
                                    .resizable()
                                    .frame(height:233)
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                                VStack{
                                    HStack{
                                        Text(dataVal.kode_alat_vendor)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.white)
                                        Button{
                                            
                                        }label:{
                                            Image(systemName: "eye")
                                                .font(.system(size: 12))
                                        }
                                        .frame(alignment: .center)
                                        .padding(5)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        Spacer()
                                        Text(dataVal.waktu_update)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.white)
                                    }
                                    Spacer()
                                    VStack{
                                        Text(dataVal.pompa)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.red)
                                            .padding(.top, 2)
                                        Text(dataVal.nama_lokasi)
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(Color.white)
                                            .padding(.top, 1)
                                        Text(dataVal.level)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.yellow)
                                            .padding(.top, 1)
                                        ZStack{
                                            Ellipse()
                                                .fill(Color(UIColor(hexString: "47DD10")))
                                                .frame(width: 70, height: 70)
                                                .shadow(color: .black.opacity(0.30), radius: 20)
                                            Text("\(dataVal.level_sensor)")
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(Color.white)
                                        }
                                        Text(dataVal.hujan)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.orange)
                                    }
                                    Spacer()
                                    HStack{
                                        Rectangle()
                                            .fill(Color(UIColor(hexString: "#47DD10")))
                                            .frame(width: 10, height: 10)
                                            .cornerRadius(50)
                                        Text("Normal")
                                            .font(.system(size: 9))
                                            .foregroundColor(Color(UIColor(hexString: "#47DD10")))
                                        Rectangle()
                                            .fill(Color(UIColor(hexString: "#FFD20A")))
                                            .frame(width: 10, height: 10)
                                            .cornerRadius(50)
                                        Text("Siaga 1")
                                            .font(.system(size: 9))
                                            .foregroundColor(Color(UIColor(hexString: "#FFD20A")))
                                        Rectangle()
                                            .fill(Color(UIColor(hexString: "#FF6E3D")))
                                            .frame(width: 10, height: 10)
                                            .cornerRadius(50)
                                        Text("Siaga 2")
                                            .font(.system(size: 9))
                                            .foregroundColor(Color(UIColor(hexString: "#FF6E3D")))
                                        
                                        Rectangle()
                                            .fill(Color(UIColor(hexString: "#F80505")))
                                            .frame(width: 10, height: 10)
                                            .cornerRadius(50)
                                        Text("Siaga 3")
                                            .font(.system(size: 9))
                                            .foregroundColor(Color(UIColor(hexString: "#F80505")))
                                        Rectangle()
                                            .fill(Color(UIColor(hexString: "#AE0000")))
                                            .frame(width: 10, height: 10)
                                            .cornerRadius(50)
                                        Text("Awas")
                                            .font(.system(size: 9))
                                            .foregroundColor(Color(UIColor(hexString: "#AE0000")))
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                    
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
            
            if dataWaterLevel.isEmpty {
                ProgressView()
            }
            
            
        }
        .onAppear{
            WaterLevelModel().getWaterLevelSensor(idruas: idSelect){ (parsedata)  in
                dataWaterLevel = parsedata
                let groupedRuas = Dictionary(grouping: parsedata) { $0.nama_ruas }
                for (key, value) in groupedRuas {
                    var idRuas = 0
                    for _ in 0 ..< value.count{
                        idRuas = value[0].ruas_id
                    }
                    dataRuas.append(initRuas(id: idRuas,ruas_id: idRuas, nama_ruas: key))
                }
            }
        }
    }
    
    var searchResults: [initRuas] {
        if search.isEmpty {
            return self.dataRuas
        } else {
            return self.dataRuas.filter { $0.nama_ruas.localizedStandardContains(search) }
        }
    }
    
}

struct initRuas: Codable, Identifiable {
    let id: Int
    let ruas_id: Int
    let nama_ruas: String
}

struct WaterLevelSensor_Previews: PreviewProvider {
    static var previews: some View {
        WaterLevelSensor()
    }
}
