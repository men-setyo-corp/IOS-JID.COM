//
//  ViewGrafikKegiatan.swift
//  JID.COM
//
//  Created by Panda on 04/10/23.
//

import SwiftUI
import Charts

struct ViewGrafikKegiatan: View {
    @ObservedObject var dataGrafikKeg = GrafikKegiatan()
    
    @State var setParmsRuas: String = ""
    @State var setParmsDari: String = ""
    @State var setParmsSampai: String = ""
    
    var body: some View {
        let dataKegiatan = [
//            (kategori: "Dalam Rencana", data: dataGrafikKeg.SetDataRencana),
            (kategori: "Proses", data: dataGrafikKeg.SetDataProses),
            (kategori: "Selesai", data: dataGrafikKeg.SetDataSelesai)
        ]
        GroupBox (label:
            HStack{
            Text("Grafik Kegiatan")
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
            Chart(dataKegiatan, id:\.kategori){ step in
                ForEach(step.data) { setdata in
                    BarMark(
                        x: .value("Kagiatan", setdata.kegiatan),
                        y: .value("Value", setdata.kategori)
                    )
                    .position(by: .value("Jenis", step.kategori))
                    .foregroundStyle(by: .value("Jenis", step.kategori))
                    .cornerRadius(10.0)
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .annotation {
                        Text("\(setdata.kategori)")
                            .font(.system(size: 8))
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .chartXAxis{
                AxisMarks(position: .bottom, values: .automatic) { value in
                    AxisValueLabel {
                        if let kegiatan = value.as(String.self) {
                            Text(kegiatan)
                                .rotationEffect(.degrees(-35))
                        }
                    }
                }
            }
            .chartForegroundStyleScale([
//                "Dalam Rencana" : Color(.systemBlue),
                "Proses": Color(.systemOrange),
                "Selesai": Color(.systemGreen)
            ])
            .chartLegend(spacing: 15)
            .padding(.vertical)
        }
        .backgroundStyle(Color(UIColor(hexString: "#BFD7FF")))
        .frame(height:350)
        .onAppear{
            dataGrafikKeg.setParmsRuas = "5"
            dataGrafikKeg.setParmsDari = "2023-01"
            dataGrafikKeg.setParmsSampai = "2023-05"
            dataGrafikKeg.GetDataDashKegiatanServer()
        }
    }
}

struct ViewGrafikKegiatan_Previews: PreviewProvider {
    static var previews: some View {
        ViewGrafikKegiatan()
    }
}
