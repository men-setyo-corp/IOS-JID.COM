//
//  GrafikPemeliharaan.swift
//  JID.COM
//
//  Created by Panda on 04/10/23.
//

import Foundation
import SwiftyJSON

class GrafikPemeliharaan: ObservableObject {
    @Published var SetDataSelesai: [IdentifiModGrafikPemeli] = []
    @Published var SetDataProses: [IdentifiModGrafikPemeli] = []
    @Published var SetDataRencana: [IdentifiModGrafikPemeli] = []
    
    @Published var setParmsRuas: String = ""
    @Published var setParmsDari: String = ""
    @Published var setParmsSampai: String = ""
    
    init(){
//        GetDataDashPemi()
//        GetDataDashPemiServer()
    }
    
    func GetDataDashPemi() {
        guard let path = Bundle.main.path(forResource: "xample", ofType: "json")
        else {
            print("File tidak ditemukan")
            return
        }
        let filePath = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: filePath)
        let getJSON = JSON(data ?? "Null data from API")
       
        if getJSON["status"].boolValue {
            let result = JSON(getJSON["data"]["result"])
            
            for (_, value) in result {
                self.SetDataSelesai.append(
                    .init(bulan: value["_id"]["bulan"].stringValue, kategori: value["selesai"].intValue)
                )
                self.SetDataProses.append(
                    .init(bulan: value["_id"]["bulan"].stringValue, kategori: value["proses"].intValue)
                )
                self.SetDataRencana.append(
                    .init(bulan: value["_id"]["bulan"].stringValue, kategori: value["rencana"].intValue)
                )
            }
        }else{
            print("Data pemeliharaan kosong")
        }
    }
    
    @objc func GetDataDashPemiServer(){
        print("get data dashboard pemeliharaan...")
        DispatchQueue.global().async{
            RestApiController().resAPIDevGet(endPoint: "dashboard_pemeliharaan/v1/getPemeliharaan?ruas="+self.setParmsRuas+"&waktu=bulan&dari="+self.setParmsDari+"&sampai="+self.setParmsSampai, method: .get){ result in
                let getJSON = JSON(result ?? "Null data from API")
                
                do{
                    if getJSON["status"].boolValue {
                        let getData = JSON(getJSON["data"]["result"])
                        self.SetDataSelesai = []
                        self.SetDataProses = []
                        for (_, value) in getData {
                            self.SetDataSelesai.append(
                                .init(bulan: value["_id"]["bulan"].stringValue, kategori: value["selesai"].intValue)
                            )
                            self.SetDataProses.append(
                                .init(bulan: value["_id"]["bulan"].stringValue, kategori: value["proses"].intValue)
                            )
                        }
                    
                    }else{
                        print("data kosong")
                        print(getJSON)
                    }
                }
            }
        }
    }
}

struct IdentifiModGrafikPemeli: Identifiable {
    var bulan: String
    var kategori: Int
    var id = UUID()
}
