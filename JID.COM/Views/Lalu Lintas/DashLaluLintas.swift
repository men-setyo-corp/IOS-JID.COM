//
//  DashLaluLintas.swift
//  JID.COM
//
//  Created by Panda on 20/09/23.
//

import SwiftUI
import SwiftyJSON

struct DashLaluLintas: View {
    private let data: [Int] = Array(1...3)
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State var dataRekayasa : JSON = []
    @State var oneway: String = "0"
    @State var contraflow: String = "0"
    @State var pengalihan: String = "0"
    
    @State var selectHari: Bool = true
    @State var selectTahun: Bool = false
    @State var selectDefault: String = "hari"
    
    @State var dateNow: String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Filter")
                    .font(.system(size: 13))
                Spacer()
                HStack{
                    Button{
                        selectTahun = true
                        selectHari = false
                        selectDefault = "tahun"
                        //set data rek
                        oneway = dataRekayasa["tahun"]["one_way"].stringValue
                        contraflow = dataRekayasa["tahun"]["contra_flow"].stringValue
                        pengalihan = dataRekayasa["tahun"]["pengalihan"].stringValue
                        
                    }label:{
                        Image(systemName: selectTahun ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 20))
                            .foregroundColor(selectTahun ? Color.blue : Color.gray)
                    }
                    Text("Tahun")
                        .font(.system(size: 13, weight: .bold))
                    
                    Button{
                        selectTahun = false
                        selectHari = true
                        selectDefault = "hari"
                        //set data rek
                        oneway = dataRekayasa["hari"]["one_way_daily"].stringValue
                        contraflow = dataRekayasa["hari"]["contra_flow_daily"].stringValue
                        pengalihan = dataRekayasa["hari"]["pengalihan_daily"].stringValue
                        
                    }label:{
                        Image(systemName: selectHari ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 20))
                            .foregroundColor(selectHari ? Color.blue : Color.gray)
                    }
                    Text("Hari")
                        .font(.system(size: 13, weight: .bold))
                }
            }
            Text("Dashboard Rekayasa Lalu Lintas")
                .font(.system(size: 13, weight: .bold))
                .padding(.top, 5)
                .padding(.bottom, 2)
            
            LazyVGrid(columns: columns, spacing: 20) {
                VStack(alignment: .leading){
                    HStack{
                        Image("oneway")
                            .font(.system(size: 25))
                        Text(oneway)
                            .font(.system(size: 20))
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    Text("One Way")
                        .font(.system(size: 13, weight: .bold))
                        .padding(.top, 5)
                        .foregroundColor(Color.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor(hexString: "#008D39")))
                .cornerRadius(10)
                .shadow(radius: 5)
                
                VStack(alignment: .leading){
                    HStack{
                        Image("contraflow")
                            .font(.system(size: 25))
                        Text(contraflow)
                            .font(.system(size: 20))
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    Text("Contra-Flow")
                        .font(.system(size: 13, weight: .bold))
                        .padding(.top, 5)
                        .foregroundColor(Color.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor(hexString: "#6D51CC")))
                .cornerRadius(10)
                .shadow(radius: 5)
               
                VStack(alignment: .leading){
                    HStack{
                        Image("pengalihan")
                            .font(.system(size: 25))
                        Text(pengalihan)
                            .font(.system(size: 20))
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    Text("Pengalihan")
                        .font(.system(size: 13, weight: .bold))
                        .padding(.top, 5)
                        .foregroundColor(Color.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(UIColor(hexString: "#FF5400")))
                .cornerRadius(10)
                .shadow(radius: 5)
                
            }
            
            Text("")
                .font(.system(size: 13, weight: .bold))
                .padding(.top, 5)
                .padding(.bottom, 2)
            Spacer()
        }
        .padding()
        .onAppear{
            
            DashboardLalinModel().getDataDashRekayasa{ resdata in
                dataRekayasa = resdata
                
                oneway = dataRekayasa["hari"]["one_way_daily"].stringValue
                contraflow = dataRekayasa["hari"]["contra_flow_daily"].stringValue
                pengalihan = dataRekayasa["hari"]["pengalihan_daily"].stringValue
            }
        }
    }
}

struct DashLaluLintas_Previews: PreviewProvider {
    static var previews: some View {
        DashLaluLintas()
    }
}
