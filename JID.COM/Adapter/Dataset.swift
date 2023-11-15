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
    public func convertDateFormat(inputDate: String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        let oldDate = olDateFormatter.date(from: inputDate)

        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return convertDateFormatter.string(from: oldDate!)
    }
    
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
            ket_tipe_gangguan: dataSet["ket_tipe_gangguan"].stringValue,
            waktu_kejadian: dataSet["waktu_kejadian"].stringValue,
            detail_kejadian: dataSet["detail_kejadian"].stringValue,
            dampak: dataSet["dampak"].stringValue,
            waktu_selsai: dataSet["waktu_selsai"].stringValue)
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
    
    public func Dataset_gerbangtoll(dataSet: JSON) -> Data_gerbang_toll{
        let data_gerbang_result = Data_gerbang_toll(
            id: dataSet["id"].intValue,
            title: dataSet["title"].stringValue,
            kode_cabang: dataSet["kode_cabang"].intValue,
            nama_gerbang: dataSet["nama_gerbang"].stringValue,
            nama_cabang: dataSet["nama_cabang"].stringValue,
            lalin_shift_1: dataSet["lalin_shift_1"].intValue,
            lalin_shift_2: dataSet["lalin_shift_2"].intValue,
            lalin_shift_3: dataSet["lalin_shift_3"].intValue,
            lalin_perjam: dataSet["lalin_perjam"].intValue,
            status: dataSet["status"].intValue,
            last_update: dataSet["title"].stringValue
        )
       return data_gerbang_result
    }
    
    public func Dataset_restarea(dataSet: JSON) -> Data_rest_area{
        let data_restarea_result = Data_rest_area(
            id_ruas: dataSet["id_ruas"].intValue,
            title: dataSet["title"].stringValue,
            kend_besar_tersedia: dataSet["kend_besar_tersedia"].intValue,
            kend_kecil_tersedia: dataSet["kend_kecil_tersedia"].intValue,
            kapasitas_kend_besar: dataSet["kapasitas_kend_besar"].intValue,
            kapasitas_kend_kecil: dataSet["kapasitas_kend_kecil"].intValue,
            kondisi: dataSet["kondisi"].stringValue,
            nama_rest_area: dataSet["nama_rest_area"].stringValue,
            status_ra: dataSet["status_ra"].stringValue,
            cctv_1: dataSet["cctv_1"].stringValue,
            cctv_2: dataSet["cctv_2"].stringValue,
            cctv_3: dataSet["cctv_3"].stringValue,
            last_update: dataSet["last_update"].stringValue
        )
       return data_restarea_result
    }
    
    public func Dataset_rtms(dataSet: JSON) -> Data_rtms{
        let data_rtms_result = Data_rtms(
            id_ruas: dataSet["id_ruas"].intValue,
            title: dataSet["title"].stringValue,
            nama_lokasi: dataSet["nama_lokasi"].stringValue,
            total_volume_jalur_a: dataSet["total_volume_jalur_a"].doubleValue,
            speed_jalur_a: dataSet["speed_jalur_a"].doubleValue,
            total_volume_jalur_b: dataSet["total_volume_jalur_b"].doubleValue,
            speed_jalur_b: dataSet["speed_jalur_b"].doubleValue,
            status: dataSet["status"].intValue,
            waktu_update: dataSet["waktu_update"].stringValue
        )
       return data_rtms_result
    }
    
    public func Dataset_rtms2(dataSet: JSON) -> Data_rtms2{
        let data_rtms2_result = Data_rtms2(
            id_ruas: dataSet["id_ruas"].intValue,
            title: dataSet["title"].stringValue,
            nama_lokasi: dataSet["nama_lokasi"].stringValue,
            cabang: dataSet["cabang"].stringValue,
            km: dataSet["km"].stringValue,
            key_id: dataSet["key_id"].stringValue,
            car: dataSet["car"].intValue,
            bus: dataSet["bus"].intValue,
            truck: dataSet["truck"].intValue,
            total_volume: dataSet["total_volume"].intValue,
            waktu_update: dataSet["waktu_update"].stringValue,
            status: dataSet["status"].intValue
        )
       return data_rtms2_result
    }
    
    public func Dataset_radar(dataSet: JSON) -> Data_radar{
        let data_radar_result = Data_radar(
            idx: dataSet["idx"].intValue,
            id_ruas: dataSet["id_ruas"].intValue,
            nama_lokasi: dataSet["nama_lokasi"].stringValue,
            vcr_jalur_a: dataSet["vcr_jalur_a"].doubleValue,
            vcr_jalur_b: dataSet["vcr_jalur_b"].doubleValue,
            last_update: dataSet["last_update"].stringValue,
            url_radar: dataSet["url_radar"].stringValue
        )
       return data_radar_result
    }
    
    public func Dataset_speed(dataSet: JSON) -> Data_speed{
        let data_speed_result = Data_speed(
            camera_id: dataSet["camera_id"].intValue,
            nama_lokasi: dataSet["nama_lokasi"].stringValue,
            cabang: dataSet["cabang"].stringValue,
            posisi: dataSet["posisi"].stringValue,
            kec_1: dataSet["kec_1"].intValue,
            kec_2: dataSet["kec_2"].intValue,
            kec_3: dataSet["kec_3"].intValue,
            total_volume: dataSet["total_volume"].intValue,
            waktu_update: dataSet["waktu_update"].stringValue
        )
       return data_speed_result
    }
    
    public func Dataset_wakterlevel(dataSet: JSON) -> Data_water_level{
        let data_watelelvel_result = Data_water_level(
            nama_lokasi: dataSet["nama_lokasi"].stringValue,
            nama_ruas: dataSet["nama_ruas"].stringValue,
            level_sensor: dataSet["level_sensor"].intValue,
            level: dataSet["level"].stringValue,
            hujan: dataSet["hujan"].stringValue,
            pompa: dataSet["pompa"].stringValue,
            waktu_update: dataSet["waktu_update"].stringValue
        )
       return data_watelelvel_result
    }
    
    public func Dataset_pompa(dataSet: JSON) -> Data_pompabanjir{
        let data_pompa_result = Data_pompabanjir(
            jenis_pompa: dataSet["jenis_pompa"].stringValue,
            no_urut_pompa: dataSet["no_urut_pompa"].stringValue,
            vol: dataSet["vol"].intValue,
            nama_pompa: dataSet["nama_pompa"].stringValue,
            kw: dataSet["kw"].stringValue,
            diameter: dataSet["diameter"].stringValue,
            km: dataSet["km"].stringValue,
            jalur: dataSet["jalur"].stringValue,
            keterangan: dataSet["keterangan"].stringValue
        )
       return data_pompa_result
    }
    
    public func Dataset_wim(dataSet: JSON) -> Data_wim{
        let data_wim_result = Data_wim(
            nama_lokasi: dataSet["nama_lokasi"].stringValue,
            Respon_Induk_PJR: dataSet["Respon_Induk_PJR"].stringValue,
            Back_Office_ETLE: dataSet["Back_Office_ETLE"].stringValue,
            waktu_update: dataSet["waktu_update"].stringValue,
            status: dataSet["status"].intValue)
       return data_wim_result
    }
    
    public var info_jalan_tol = ["Jalan Tol","Batas KM","Jalan Penghubung","Gerbang Tol","Rest Area","Kondisi Traffic","Roughness Index"]
    
    public var sisinfokom = ["DMS","CCTV","Traffic Counting (RTMS)","Monitoring Traffic (Radar)","Speed Camp","Water Level Sensor","Pompa Banjir","WIM Bridge","GPS Kendaraan Operasional","Sepeda Motor"]
    
    public var event_jalan_tol = ["Gangguan Lalin","Rekayasa Lalin","Pemeliharaan"]
    
    
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
