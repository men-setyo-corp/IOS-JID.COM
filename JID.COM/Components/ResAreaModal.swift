//
//  ResAreaModal.swift
//  JID.COM
//
//  Created by Panda on 17/12/22.
//

import SwiftUI

struct ResAreaModal: View {
    @Environment(\.presentationMode) var presentationMode
    
    var dataResult : Data_rest_area
    @State var urlSet : String = ""
    @State var stopRun: Bool = true
    @State var btn1 : Bool = false
    @State var btn2 : Bool = false
    @State var btn3 : Bool = false
    
    var body: some View {
        VStack{
            VStack{
                VStack(alignment: .leading, spacing: 0){
                    AsyncImage(url: URL(string: urlSet)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                        } else if phase.error != nil {
                            CardShimmerRestArea()
                        } else {
                            CardShimmerRestArea()
                        }
                    }
                    .frame(height: 170)
                    .background(Color.white)
                    
                    HStack{
                        Image("logocctv")
                        VStack(alignment: .leading){
                            Text("Lokasi")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.50))
                            Text("Rest Area \(dataResult.nama_rest_area)")
                                .font(.system(size: 15))
                                .foregroundColor(Color.white)
                        }
                        Spacer()
                        Button{
                            urlSet = dataResult.cctv_1
                            btn1 = true
                            btn2 = false
                            btn3 = false
                        }label: {
                            Text("1")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(btn1 ? Color(UIColor(hexString: "#FFFFFF")) : Color(UIColor(hexString: "#000000")))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                        }
                        .background(btn1 ? Color(UIColor(hexString: "#344879")) : Color(UIColor(hexString: "#DFEFFF")))
                        .cornerRadius(5)
                        
                        Button{
                            urlSet = dataResult.cctv_2
                            btn1 = false
                            btn2 = true
                            btn3 = false
                        }label: {
                            Text("2")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(btn2 ? Color(UIColor(hexString: "#FFFFFF")) : Color(UIColor(hexString: "#000000")))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                        }
                        .background(btn2 ? Color(UIColor(hexString: "#344879")) : Color(UIColor(hexString: "#DFEFFF")))
                        .cornerRadius(5)
                        Button{
                            urlSet = dataResult.cctv_3
                            btn1 = false
                            btn2 = false
                            btn3 = true
                        }label: {
                            Text("3")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(btn3 ? Color(UIColor(hexString: "#FFFFFF")) : Color(UIColor(hexString: "#000000")))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                        }
                        .background(btn3 ? Color(UIColor(hexString: "#344879")) : Color(UIColor(hexString: "#DFEFFF")))
                        .cornerRadius(5)
                        .padding(.trailing, 10)
                    }
                    .frame(alignment: .leading)
                    
                }
                .background(Color(UIColor(hexString: "#344879")))
                .cornerRadius(10)
                
                VStack{
                    HStack
                    {
                        Text("Kendaraan Parkir")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                    }
                    HStack
                    {
                        Text("Kendaraan Kecil")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(dataResult.kapasitas_kend_kecil)")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Kendaraan Besar")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(dataResult.kapasitas_kend_besar)")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Kendaraan Tersedia")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Kendaraan Kecil")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(dataResult.kend_kecil_tersedia)")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Kendaraan Besar")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(dataResult.kend_besar_tersedia)")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                    }.padding(.top, 3)
                    
                    
                    Divider()
                     .frame(height: 1)
                     .padding(.horizontal, 10)
                     .background(Color(UIColor(hexString: "#DFEFFF")))
                    HStack{
                        Text("Kondisi")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(dataResult.kondisi)")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                    }
                    .padding(.top, 3)
                    HStack{
                        Text("Status")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(dataResult.status_ra)")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                    }
                    .padding(.top, 3)
                    HStack{
                        Text("Last Update")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(dataResult.last_update)")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                    }
                    .padding(.top, 3)
                    
                }
                
                Button("Tutup") {
                    stopRun = false
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color.red)
                .font(.system(size: 14))
                .padding(.top, 4)
            }
        }
        .frame(width: 310)
        .padding(15)
        .background(Color.white)
        .cornerRadius(10)
        .onAppear{
            btn1 = true
            btn2 = false
            btn3 = false
            urlSet = dataResult.cctv_1
        }
        
    }
}

struct ResAreaModal_Previews: PreviewProvider {
    static let sendDataRestArea = Data_rest_area(id_ruas: 0, title: "", kend_besar_tersedia: 0, kend_kecil_tersedia: 0, kapasitas_kend_besar: 0, kapasitas_kend_kecil: 0, kondisi: "", nama_rest_area: "", status_ra: "", cctv_1: "", cctv_2: "", cctv_3: "", last_update: "")
    
    static var previews: some View {
        ResAreaModal(dataResult: sendDataRestArea)
    }
}

struct CardShimmerRestArea: View {
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body: some View{
        ZStack{
            Color.black.opacity(0.09)
            
            Color.white
            .mask(
                Rectangle()
                .fill(
                    LinearGradient(gradient: .init(colors: [.clear, Color.white.opacity(0.18)]), startPoint: .top, endPoint: .bottom)
                )
                .rotationEffect(.init(degrees: 75))
                .offset(x: self.show ? center: -center)
            )
        }
        .onAppear{
            withAnimation(Animation.default.speed(0.35).delay(0).repeatForever(autoreverses: false)){
                self.show.toggle()
            }
        }
    }
}
