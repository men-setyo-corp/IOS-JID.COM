//
//  WaterLevelSensor.swift
//  JID.COM
//
//  Created by Panda on 03/11/23.
//

import SwiftUI
import SwiftyJSON
import SheetDetentsModifier

struct WaterLevelSensor: View {
    @State var dataWaterLevel : [InitDataWL] = []
    @State var dataRuas : [initRuas] = []
    @State private var selectedOptionWL = "Pilih Ruas"
    @State var search = ""
    @State var searchWl = ""
    @State var ruasSelect = "SEMUA RUAS"
    @State var idSelect = 0
    @State var filterRuas = false
    @State var showCCTV = false
    @State var colorWater = "#000000"
    @State var isDisabled = true
    @State var playCCTV: Bool = true;
    @State var urlSet = ""
    @State var nmLokasi = ""
    @State private var sheetHeight: CGFloat = .zero
    
    var body: some View {
        ZStack{
            VStack{
                TextField(" Ruas", text: $searchWl)
                    .disabled(isDisabled)
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
                                .foregroundColor(.gray)
                                .font(.system(size: 13))
                                .padding(.trailing, 10)
                        }
                    )
                    .padding(.bottom, 10)
                    .onTapGesture{
                        filterRuas = true
                        isDisabled = false
                    }
                    .sheet(isPresented: $filterRuas){
                        ZStack{
                            Color.white.edgesIgnoringSafeArea(.all)
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
                                    .foregroundColor(.black)
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
                                                dataWaterLevel = []
                                                filterRuas = false
                                                ruasSelect = Rua.nama_ruas
                                                WaterLevelModel().getWaterLevelSensor(idruas: Rua.ruas_id){ (parsedata)  in
                                                    dataWaterLevel = parsedata
                                                    search.removeAll()
                                                    isDisabled = true
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
                        }
                        .presentationDetents([.medium])
                    }
                
                
                Spacer()
                if dataWaterLevel.isEmpty {
                    ProgressView()
                        .tint(.black)
                    
                }else{
                    ScrollView{
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
                                            nmLokasi = dataVal.nama_lokasi
                                            urlSet = dataVal.url_cctv
                                            print(urlSet, nmLokasi)
                                            showCCTV = true
                                        }label:{
                                            Image(systemName: "eye")
                                                .font(.system(size: 12))
                                        }
                                        .frame(alignment: .center)
                                        .padding(5)
                                        .background(Color.white)
                                        .cornerRadius(5)
                                        
                                        Spacer()
                                        Text(Dataset().convertDateFormat(inputDate: dataVal.waktu_update))
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
                                            .foregroundColor(dataVal.level == "NORMAL" ? Color(UIColor(hexString: "47DD10")) : dataVal.level == "SIAGA 1" ? Color(UIColor(hexString: "#FFD20A")) : dataVal.level == "SIAGA 2" ? Color(UIColor(hexString: "#FF6E3D")) : dataVal.level == "SIAGA 3" ? Color(UIColor(hexString: "#F80505")) : Color(UIColor(hexString: "#AE0000")))
                                            .padding(.top, 1)
                                        ZStack{
                                            Ellipse()
                                                .fill(dataVal.level == "NORMAL" ? Color(UIColor(hexString: "47DD10")) : dataVal.level == "SIAGA 1" ? Color(UIColor(hexString: "#FFD20A")) : dataVal.level == "SIAGA 2" ? Color(UIColor(hexString: "#FF6E3D")) : dataVal.level == "SIAGA 3" ? Color(UIColor(hexString: "#F80505")) : Color(UIColor(hexString: "#AE0000")))
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
                    .sheet(isPresented: $showCCTV){
                        ZStack{
                            Color.white.edgesIgnoringSafeArea(.all)
                            VStack{
                                Text("\(nmLokasi)")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.top, 5)
                                Spacer()
                                AsyncImage(url: URL(string:urlSet)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .onAppear{
                                                startRun(uri_set: urlSet)
                                            }
                                    } else if phase.error != nil {
                                        ProgressView()
                                            .tint(.black)
                                    } else {
                                        ProgressView()
                                            .tint(.black)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical)
                        }
                        .presentationDetents([.medium])
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical)
            
//            if dataWaterLevel.isEmpty {
//                ProgressView()
//                    .tint(.white)
//            }
        }
        .onAppear{
            WaterLevelModel().getWaterLevelSensor(idruas: idSelect){ (parsedata)  in
                dataWaterLevel = parsedata
                let groupedRuas = Dictionary(grouping: parsedata) { $0.nama_ruas }
                dataRuas.append(initRuas(id: 0,ruas_id: 0, nama_ruas: "SEMUA RUAS"))
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
    
    private func startRun(uri_set:String) {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            urlSet = uri_set
           if showCCTV == false {
               timer.invalidate()
               print("stop..")
           }
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
