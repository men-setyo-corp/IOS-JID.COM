//
//  Sheetbottomview.swift
//  JID.COM
//
//  Created by Macbook on 29/08/22.
//

import UIKit
import SwiftyJSON
import SwiftUI

class Sheetbottomview: UIViewController {
    public func modalSheet(dataSet: JSON){
        let writerForSecondView = Data_pemeliharaan(
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
        
        let nav = UIHostingController(rootView: SetBottomSheet(writer: writerForSecondView))
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController{
            sheet.detents = [.medium(), .large()]
        }
        present(nav, animated: true, completion: nil)
    }
}
