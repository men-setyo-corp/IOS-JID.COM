//
//  GrafikKegiatan.swift
//  JID.COM
//
//  Created by Panda on 04/10/23.
//

import Foundation
import SwiftyJSON

class GrafikKegiatan: ObservableObject {
    @Published var SetDataSelesai: [IdentifiModGrafKegiatan] = []
    @Published var SetDataProses: [IdentifiModGrafKegiatan] = []
    @Published var SetDataRencana: [IdentifiModGrafKegiatan] = []
    
    @Published var setParmsRuas: String = ""
    @Published var setParmsDari: String = ""
    @Published var setParmsSampai: String = ""
    
    init(){
        print("run get data kegiatan...")
//        GetDataDashKegiatan()
//        GetDataDashKegiatanServer()
    }
    
    func GetDataDashKegiatan() {
        guard let path = Bundle.main.path(forResource: "datakegiatan", ofType: "json")
        else {
            print("File kegiatan tidak ditemukan")
            return
        }
        let filePath = URL(fileURLWithPath: path)
        let data = try? Data(contentsOf: filePath)
        let getJSON = JSON(data ?? "Null data from API")
       
        if getJSON["status"].boolValue {
            let result = JSON(getJSON["data"])

            for (_, value) in result {
                self.SetDataSelesai.append(
                    .init(kegiatan: value["ket_jenis_kegiatan"].stringValue, kategori: value["selesai"].intValue)
                )
                self.SetDataProses.append(
                    .init(kegiatan: value["ket_jenis_kegiatan"].stringValue, kategori: value["proses"].intValue)
                )
                self.SetDataRencana.append(
                    .init(kegiatan: value["ket_jenis_kegiatan"].stringValue, kategori: value["rencana"].intValue)
                )
            }
        }else{
            print("data kosong")
        }
    }
    
    @objc func GetDataDashKegiatanServer(){
        print("get data dashboard kegiatan...")
        DispatchQueue.global().async{
            RestApiController().resAPIGet(endPoint: "dashboard_pemeliharaan/v1/getKegiatanTot?ruas="+self.setParmsRuas+"&waktu=bulan&dari="+self.setParmsDari+"&sampai="+self.setParmsSampai, method: .get){ result in
                let getJSON = JSON(result ?? "Null data from API")
                do{
                    if getJSON["status"].boolValue {
                        let getData = JSON(getJSON["data"])
                        var namaKegiatan: String
                        for (_, value) in getData {
                            if value["ket_jenis_kegiatan"].stringValue != "Pilih Jenis Kegiatan" {
                                if value["ket_jenis_kegiatan"].stringValue == "Scrapping Filling Overlay (SFO)" {
                                    namaKegiatan = "SFO"
                                }else if value["ket_jenis_kegiatan"].stringValue == "Pekerjaan lainnya" {
                                    namaKegiatan = "Lainnya"
                                }else if value["ket_jenis_kegiatan"].stringValue == "Pekerjaan Sarana Keselamatan Jalan" {
                                    namaKegiatan = "Sarana"
                                }else if value["ket_jenis_kegiatan"].stringValue == "Pekerjaan Marka" {
                                    namaKegiatan = "Marka"
                                }else if value["ket_jenis_kegiatan"].stringValue == "Pekerjaan Jembatan" {
                                    namaKegiatan = "Jembatan"
                                }else if value["ket_jenis_kegiatan"].stringValue == "Pekerjaan Expansion Joint" {
                                    namaKegiatan = "Expansion Joint"
                                }else if value["ket_jenis_kegiatan"].stringValue == "Rekonstruksi" {
                                    namaKegiatan = "Rekonstruksi"
                                }else if value["ket_jenis_kegiatan"].stringValue == "Pelebaran Jalan" {
                                    namaKegiatan = "Pelebaran"
                                }else if value["ket_jenis_kegiatan"].stringValue == "Patching" {
                                    namaKegiatan = "Patching"
                                }else{
                                    namaKegiatan = value["ket_jenis_kegiatan"].stringValue
                                }
                                self.SetDataSelesai.append(
                                    .init(kegiatan: namaKegiatan, kategori: value["selesai"].intValue)
                                )
                                self.SetDataProses.append(
                                    .init(kegiatan: namaKegiatan, kategori: value["proses"].intValue)
                                )
                            }
                        }
                    }else{
                        print("data kosong")
                    }
                }
            }
        }
    }
}

struct IdentifiModGrafKegiatan: Identifiable {
    var kegiatan: String
    var kategori: Int
    var id = UUID()
}
