//
//  Rtms2Modal.swift
//  JID.COM
//
//  Created by Panda on 17/12/22.
//

import SwiftUI

struct Rtms2Modal: View {
    @Environment(\.presentationMode) var presentationMode
    
    var dataResult : Data_rtms2
    @State var urlSet : String = ""
    @State var stopRun: Bool = true
    
    var body: some View {
        VStack{
            VStack{
                VStack(alignment: .leading, spacing: 0){
                    AsyncImage(url: URL(string: urlSet)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                        } else if phase.error != nil {
                            ProgressView()
                        } else {
                            CardShimmerRtms2()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 170)
                    .background(Color.white)
                    
                    HStack{
                        Image("logocctv")
                        VStack(alignment: .leading){
                            Text("Lokasi")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.50))
                            Text("\(dataResult.cabang), \(dataResult.nama_lokasi)")
                                .font(.system(size: 15))
                                .foregroundColor(Color.white)
                        }
                        Spacer()
                        
                    }
                    .frame(alignment: .leading)
                    
                }
                .background(Color(UIColor(hexString: "#344879")))
                .cornerRadius(10)
                
                VStack{
                    HStack
                    {
                        Text("Jenis Kendaraan")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                    }
                    HStack
                    {
                        Text("Car")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(dataResult.car)")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Bus")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(dataResult.bus)")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Truck")
                            .font(.system(size: 12))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(dataResult.truck)")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                    }.padding(.top, 3)
                    
                    Divider()
                     .frame(height: 1)
                     .padding(.horizontal, 10)
                     .background(Color(UIColor(hexString: "#DFEFFF")))
                    HStack{
                        Text("Total")
                            .foregroundColor(.black)
                            .font(.system(size: 12))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Text("\(dataResult.total_volume)")
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
                        Text("\(dataResult.waktu_update)")
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
            if dataResult.status  != 0 {
                startRunSnap()
            }
        }
    }
    
    private func startRunSnap() {
        urlSet = "https://jid.jasamarga.com/cctv2/\(dataResult.key_id)?tx=\(Float.random(in: 0...1))"
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            urlSet = "https://jid.jasamarga.com/cctv2/\(dataResult.key_id)?tx=\(Float.random(in: 0...1))"
            
            if stopRun == false {
                timer.invalidate()
                print("stop...")
            }
         }
    }
    
}

struct Rtms2Modal_Previews: PreviewProvider {
    static let sendData = Data_rtms2(id_ruas: 0, title: "", nama_lokasi: "", cabang: "", km: "", key_id: "", car: 0, bus: 0, truck: 0, total_volume: 0, waktu_update: "", status: 0)
    
    static var previews: some View {
        Rtms2Modal(dataResult: sendData)
    }
}

struct CardShimmerRtms2: View {
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
