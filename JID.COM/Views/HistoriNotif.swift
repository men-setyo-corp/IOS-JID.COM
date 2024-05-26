//
//  HistoriNotif.swift
//  JID.COM
//
//  Created by Panda on 21/12/22.
//

import SwiftUI
import Foundation

struct HistoriNotif: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var modelLogin : LoginModel = LoginModel()
    @State var datahistori : [Gethistori] = []
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button{
                        self.presentationMode.wrappedValue.dismiss()
                    }label:{
                        Text(Image(systemName: "chevron.backward"))
                            .foregroundColor(Color(UIColor(hexString: "#323232")))
                            .font(.system(size: 20, weight: .bold))
                    }
                    Spacer()
                    Text("Histori Notifikasi")
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                .padding(.horizontal,25)
               
                ScrollView{
                    if datahistori.isEmpty{
                        ForEach(0...10,id: \.self){_ in
                            CardShimmerHistori()
                        }
                    }else{
                        ForEach(datahistori) { gethistori in
                            VStack(alignment: .leading){
                                HStack{
                                    VStack(alignment: .leading){
                                        HStack{
                                            Text(gethistori.tipe_event)
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(Color.black)
                                            Spacer()
                                            Text(formatBandingDate(date: gethistori.created_at))
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(Color.black)
                                        }
                                        Text(gethistori.ket_status)
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.black)
                                        Text(gethistori.ket_jenis_event)
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.black)
                                        Text(gethistori.detail_ket_jenis_event)
                                            .font(.system(size: 12))
                                            .foregroundColor(Color.black)
                                        
                                        Divider()
                                         .frame(height: 1)
                                         .padding(.horizontal, 10)
                                         .background(Color(UIColor(hexString: "#DFEFFF")))
                                        Text("\(gethistori.nama_ruas) / \(gethistori.km) / \(gethistori.jalur)")
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.black)
                                        Text(formatStringDate(date: gethistori.tanggal))
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(Color.black)
                                    }
                                    Spacer()
                                }
                                Divider()
                                 .frame(height: 1)
                                 .padding(.horizontal)
                                 .background(Color(UIColor(hexString: "#000000")))
                            }
                            .padding(.bottom, 15)
                            .padding(.horizontal, 25)
                        }
                    }
                }
                .padding(.vertical, 15)
                
            }
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            HistoriNotifModel().loadHistori{ (dataresult) in
                datahistori = dataresult
                LoginModel().statusNotif = 0
            }
        }
    }
    
    func formatStringDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let newDate = dateFormatter.date(from: date)
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM d, yyyy HH:mm")
        return dateFormatter.string(from: newDate!)
    }
    
    func formatBandingDate(date: String) -> String {
        let dateNow = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let newDate = dateFormatter.date(from: date)
        
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM d, yyyy")
        let nowDate = dateFormatter.string(from: dateNow)
        let connewDate = dateFormatter.string(from: newDate!)
        
        dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        let jam = dateFormatter.string(from: newDate!)
        
        var saydate = ""
        if connewDate == nowDate {
            saydate = "Hari ini \(jam)"
        }else{
            saydate = date
        }
        
        return saydate
    }
    
}

struct HistoriNotif_Previews: PreviewProvider {
    static var previews: some View {
        HistoriNotif()
    }
}


struct CardShimmerHistori: View {
    
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body: some View{
        ZStack{
            Color.black.opacity(0.09)
            .frame(height:150)
            .cornerRadius(16)
            
            Color.white
            .frame(height:150)
            .cornerRadius(16)
            .mask(
                Rectangle()
                .fill(
                    LinearGradient(gradient: .init(colors: [.clear, Color.white.opacity(0.18)]), startPoint: .top, endPoint: .bottom)
                )
                .rotationEffect(.init(degrees: 70))
                .offset(x: self.show ? center: -center)
            )
        }
        .padding(.top, 10)
        .padding(.horizontal)
        .onAppear{
//            withAnimation(Animation.default.speed(0.35).delay(0).repeatForever(autoreverses: false)){
//                self.show.toggle()
//            }
        }
    }
}
