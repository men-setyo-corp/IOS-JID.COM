//
//  Initdata.swift
//  JID.COM
//
//  Created by Macbook on 29/08/22.
//

import Foundation

struct Data_pemeliharaan {
    var title: String
    var idx: Int
    var id_ruas: Int
    var ket_status: String
    var nama_ruas: String
    var km: String
    var jalur: String
    var lajur: String
    var range_km_pekerjaan: String
    var waktu_awal: String
    var waktu_akhir: String
    var ket_jenis_kegiatan: String
    var keterangan_detail: String
}

struct Data_gangguan {
    var title: String
    var idx: Int
    var id_ruas: Int
    var ket_status: String
    var nama_ruas: String
    var km: String
    var jalur: String
    var lajur: String
    var ket_tipe_gangguan: String
    var waktu_kejadian: String
    var detail_kejadian: String
    var dampak: String
    var waktu_selsai: String
}

struct Data_cctv {
    var title: String
    var id_ruas: Int
    var nama_ruas: String
    var nama_ruas_2: String
    var nama: String
    var status: String
    var km: String
    var key_id: String
    var arteri: Int
    var is_hls: Bool
}

struct Data_vms {
    var title: String
    var id_ruas: Int
    var nama_tol: String
    var nama_lokasi: String
    var kode_lokasi: String
    var cabang: String
    var jml_pesan: Int
    var waktu_kirim_terakhir: String
    var status_koneksi: String
}

struct Data_cctvlist {
    var title: String = "cctv list"
    var id_ruas: Int
    var nama: String
    var cabang: String
    var status: String
    var km: String
    var key_id: String
    var arteri: Int
}

struct Data_event_lalin {
    var id: Int
    var title: String
    var nama_ruas: String
    var nama_ruas_2: String
    var km: String
    var jalur: String
    var lajur: String
    var waktu: String
    var jenis_event: String
    var arah_jalur: String
    var ket_status: String
    var ket: String
    var range_km: String
    var waktu_end:  String
}


struct Data_gerbang_toll {
    var id: Int
    var title: String
    var kode_cabang: Int
    var nama_gerbang: String
    var nama_cabang: String
    var lalin_shift_1: Int
    var lalin_shift_2: Int
    var lalin_shift_3: Int
    var lalin_perjam: Int
    var status: Int
    var last_update: String
}

struct Data_rest_area {
    var id_ruas: Int
    var title: String
    var kend_besar_tersedia: Int
    var kend_kecil_tersedia: Int
    var kapasitas_kend_besar: Int
    var kapasitas_kend_kecil: Int
    var kondisi: String
    var nama_rest_area: String
    var status_ra: String
    var cctv_1: String
    var cctv_2: String
    var cctv_3: String
    var last_update: String
}

struct Data_rtms {
    var id_ruas: Int
    var title: String
    var nama_lokasi: String
    var total_volume_jalur_a: Double
    var speed_jalur_a: Double
    var total_volume_jalur_b: Double
    var speed_jalur_b: Double
    var status: Int
    var waktu_update: String
}

struct Data_rtms2 {
    var id_ruas: Int
    var title: String
    var nama_lokasi: String
    var cabang: String
    var km: String
    var key_id: String
    var car: Int
    var bus: Int
    var truck: Int
    var total_volume: Int
    var waktu_update:  String
    var status: Int
}

struct Data_radar {
    var idx: Int
    var id_ruas: Int
    var nama_lokasi: String
    var vcr_jalur_a: Double
    var vcr_jalur_b: Double
    var last_update: String
    var url_radar: String
}

struct Data_speed {
    var camera_id: Int
    var nama_lokasi: String
    var cabang: String
    var posisi: String
    var kec_1: Int
    var kec_2: Int
    var kec_3: Int
    var total_volume : Int
    var waktu_update : String
}

struct Data_water_level {
    var nama_lokasi: String
    var nama_ruas: String
    var level_sensor: Int
    var level: String
    var hujan: String
    var pompa: String
    var waktu_update : String
}

struct Data_pompabanjir {
    var jenis_pompa: String
    var no_urut_pompa: String
    var vol: Int
    var nama_pompa: String
    var kw: String
    var diameter: String
    var km : String
    var jalur : String
    var keterangan : String
}

struct Data_wim {
    var nama_lokasi: String
    var Respon_Induk_PJR: String
    var Back_Office_ETLE: String
    var waktu_update: String
    var status: Int
}

