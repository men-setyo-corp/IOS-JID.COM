//
//  Dataset.swift
//  JID.COM
//
//  Created by Macbook on 29/08/22.
//

import Foundation
import SwiftyJSON
import Alamofire
import MapboxMaps


class Dataset{
    
    public func Dataset_pemeliharaan(dataSet: JSON) -> Data_pemeliharaan{
        let data_pemeliharaan_result = Data_pemeliharaan(
            title: dataSet["title"].stringValue,
            idx: dataSet["idx"].intValue,
            id_ruas: dataSet["id_ruas"].intValue,
            ket_status: dataSet["ket_status"].stringValue,
            nama_ruas: dataSet["nama_ruas"].stringValue,
            km: dataSet["km"].stringValue,
            jalur: dataSet["jalur"].stringValue,
            lajur: dataSet["lajur"].stringValue,
            range_km_pekerjaan: dataSet["range_km_pekerjaan"].stringValue,
            waktu_awal: dataSet["waktu_awal"].stringValue,
            waktu_akhir: dataSet["waktu_akhir"].stringValue,
            ket_jenis_kegiatan: dataSet["ket_jenis_kegiatan"].stringValue,
            keterangan_detail: dataSet["keterangan_detail"].stringValue
        )
       return data_pemeliharaan_result
    }
    
    public func Dataset_gangguan(dataSet: JSON) -> Data_gangguan{
        let data_gangguan_result = Data_gangguan(
            title: dataSet["title"].stringValue,
            idx: dataSet["idx"].intValue,
            id_ruas: dataSet["id_ruas"].intValue,
            ket_status: dataSet["ket_status"].stringValue,
            nama_ruas: dataSet["nama_ruas"].stringValue,
            km: dataSet["km"].stringValue,
            jalur: dataSet["jalur"].stringValue,
            lajur: dataSet["lajur"].stringValue,
            range_km_pekerjaan: dataSet["range_km_pekerjaan"].stringValue,
            waktu_awal: dataSet["waktu_awal"].stringValue,
            waktu_akhir: dataSet["waktu_akhir"].stringValue,
            ket_jenis_kegiatan: dataSet["ket_jenis_kegiatan"].stringValue,
            keterangan_detail: dataSet["keterangan_detail"].stringValue
        )
       return data_gangguan_result
    }
    
    public func Dataset_cctv(dataSet: JSON) -> Data_cctv{
        let data_cctv_result = Data_cctv(
            title: dataSet["title"].stringValue,
            id_ruas: dataSet["id_ruas"].intValue,
            nama_ruas: dataSet["nama_ruas"].stringValue,
            nama_ruas_2: dataSet["nama_ruas_2"].stringValue,
            nama: dataSet["nama"].stringValue,
            status: dataSet["status"].stringValue,
            km: dataSet["km"].stringValue,
            key_id: dataSet["key_id"].stringValue,
            arteri: dataSet["arteri"].intValue
        )
       return data_cctv_result
    }
    
    public func Dataset_vms(dataSet: JSON) -> Data_vms{
        let data_vms_result = Data_vms(
            title: dataSet["title"].stringValue,
            id_ruas: dataSet["id_ruas"].intValue,
            nama_lokasi: dataSet["nama_lokasi"].stringValue,
            kode_lokasi: dataSet["kode_lokasi"].stringValue,
            cabang: dataSet["cabang"].stringValue,
            jml_pesan: dataSet["jml_pesan"].intValue,
            waktu_kirim_terakhir: dataSet["waktu_kirim_terakhir"].stringValue,
            status_koneksi: dataSet["status_koneksi"].stringValue
        )
       return data_vms_result
    }
    
    public func Dataset_cctvlist(dataSet: JSON) -> Data_cctvlist{
        let data_cctv_result = Data_cctvlist(
            title: dataSet["title"].stringValue,
            id_ruas: dataSet["id_ruas"].intValue,
            nama: dataSet["nama"].stringValue,
            cabang: dataSet["cabang"].stringValue,
            status: dataSet["status"].stringValue,
            km: dataSet["km"].stringValue,
            key_id: dataSet["key_id"].stringValue,
            arteri: dataSet["arteri"].intValue
        )
       return data_cctv_result
    }
    
    public let info_jalan_tol = ["Jalan Tol","Batas KM","Jalan Penghubung","Gerbang Tol","Rest Area","Kondisi Traffic","Roughness Index"]
    
//    public let sisinfokom = ["DMS","CCTV Main Road","CCTV Arteri","CCTV Genangan","CCTV Gerbang","CCTV SS","CCTV Ramp","Traffic Counting (RTMS)","Smart Traffic Counting (CCTV)","Speed Camp","Water Level Sensor","Pompa Banjir","WIM Bridge","GPS Kendaraan Operasional","Sepeda Motor"]
    public let sisinfokom = ["DMS","CCTV","Traffic Counting (RTMS)","Smart Traffic Counting (CCTV)","Speed Camp","Water Level Sensor","Pompa Banjir","WIM Bridge","GPS Kendaraan Operasional","Sepeda Motor"]
    
    public let event_jalan_tol = ["Gangguan Lalin","Rekayasa Lalin","Pemeliharaan"]
    
    //status layer
    public static var stsInfoJalanTol : [String] {
        set {
            UserDefaults.standard.set(newValue, forKey: "stsInfo")
        }
        get{
            return UserDefaults.standard.object(forKey: "stsInfo") as? [String] ?? [String]()
        }
    }
    
    //layer sisinfokom
    public static var stsSisinfokom : [String] {
        set {
            UserDefaults.standard.set(newValue, forKey: "stsSisin")
        }
        get{
            return UserDefaults.standard.object(forKey: "stsSisin") as? [String] ?? [String]()
        }
    }
    
    //layer Event jaan tol
    public static var stsEventTol : [String] {
        set {
            UserDefaults.standard.set(newValue, forKey: "stsEvent")
        }
        get{
            return UserDefaults.standard.object(forKey: "stsEvent") as? [String] ?? [String]()
        }
    }
    
    
    
}
