//
//  ViewGrafikPerJalur.swift
//  JID.COM
//
//  Created by Panda on 04/10/23.
//

import SwiftUI
import DGCharts

struct ViewGrafikPerJalur: View {
    @State private var pieChartEntries: [PieChartDataEntry] = []
    @State private var categori: Jalur.Category = .perjalur
    
    
    var options = ["Januari", "Febuari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"]
    var reginal = ["All", "Metropolitan", "Transjawa", "Nusantara"]
    
    var bulan =  Calendar.current.component(.month, from: Date())
    
    @State private var selectedOptionDari = ""
    @State private var selectedOptionSampai = ""
    @State private var selectedRegional = 0
    
    @State private var waktuDari = ""
    @State var search = ""
    @State var dataruas : [GetRuasApi] = []
    @State var ruasSelect = "All"
    @State var idruas = 0
    @State var placeholderRuas = "Cari ruas"
    
    var body: some View {
        
        
        GroupBox (label:
            HStack{
                Text("Grafik Per - Jalur")
                    .foregroundColor(Color(UIColor(hexString: "#390099")))
                    .font(.system(size: 14))
                    Spacer()
                Button{

                }label:{
                    HStack{
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 12))
                        Text("Filter")
                            .font(.system(size: 12))
                            .foregroundColor(Color(UIColor(hexString: "#390099")))
                    }
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    
                }
                .background(Color(UIColor(hexString: "#FFFFFF")))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(UIColor(hexString: "#DADADA")), lineWidth: 1)
                )
                
            
        }) {
            GrafikPerjalur(entries: Jalur.entriesForJalur(Jalur.allJalur, category: categori))
        }
        .backgroundStyle(Color(UIColor(hexString: "#BFD7FF")))
        .frame(height:350)
        
    }
    
    
    
}


struct ViewGrafikPerJalur_Previews: PreviewProvider {
    static var previews: some View {
        ViewGrafikPerJalur()
    }
}

struct ValuePerCategory {
    var category: String
    var value: Double
}
