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
    var range_km_pekerjaan: String
    var waktu_awal: String
    var waktu_akhir: String
    var ket_jenis_kegiatan: String
    var keterangan_detail: String
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
}

struct Data_vms {
    var title: String
    var id_ruas: Int
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

