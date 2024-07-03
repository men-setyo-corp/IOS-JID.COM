//
//  vmsModal.swift
//  JID.COM
//
//  Created by Panda on 13/12/22.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImage

struct vmsModal: View {
    @Environment(\.presentationMode) var presentationMode
    
    var modelLogin : LoginModel = LoginModel()
    var dataResult : Data_vms
    @State var urlSet : String = ""
    @State var stopRun: Bool = true
    
    var body: some View {
        VStack{
            VStack{
                VStack(alignment: .leading, spacing: 0){
                    HStack{
                        Spacer()
                        if dataResult.status_koneksi == "TERPUTUS" {
                            Text("DMS OFF")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .frame(height: 60)
                        }else{
                            AsyncImage(url: URL(string: urlSet)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                }else if phase.error != nil {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    ProgressView()
                                        .tint(.white)
                                }
                            }
                            .frame(height: 60)
                            .background(.black)
                        }
                        
                        Spacer()
                    }
                    .background(.black)
                    
                    HStack{
                        Image("logocctv")
                        VStack(alignment: .leading){
                            Text("Lokasi")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.50))
                            Text(dataResult.nama_lokasi)
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
                    Text("Nama Segment")
                        .font(.system(size: 13))
                        .foregroundColor(Color.black.opacity(0.50))
                    Text(dataResult.nama_tol)
                        .font(.system(size: 13))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .padding(.top, 0.5)
                    Text(dataResult.waktu_kirim_terakhir)
                        .font(.system(size: 13))
                        .foregroundColor(Color.black)
                        .padding(.top, 0.5)
                    
                    Button("Close") {
                        stopRun = false
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color.red)
                    .font(.system(size: 14))
                    .padding(.top, 4)
                }
                .padding(.top, 5)
            }
        }
        .frame(width: 310)
        .padding(15)
        .background(Color.white)
        .cornerRadius(10)
        .onAppear{
            if dataResult.status_koneksi  != "TERPUTUS" {
                startRunSnap()
            }
        }
      
    }
    
    private func startRunSnap() {
        var nourut = 0;
        //https://api-provider-jid.jasamarga.com/client-api/getimg/GTCIMANGGISGOLF/1
        urlSet = "https://api-provider-jid.jasamarga.com/client-api/getimg/\(dataResult.kode_lokasi)/1"
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { timer in
            nourut = nourut + 1
            urlSet = "https://api-provider-jid.jasamarga.com/client-api/getimg/\(dataResult.kode_lokasi)/\(nourut)"
            print(nourut)
            
            if stopRun == false {
               timer.invalidate()
               print("stop...")
            }
            if nourut == dataResult.jml_pesan {
                nourut = 0
            }
        }
    }
    
}


struct vmsModal_Previews: PreviewProvider {
    static let sendDataVms = Data_vms(title: "", id_ruas: 0, nama_tol:"", nama_lokasi: "", kode_lokasi: "", cabang: "", jml_pesan: 0, waktu_kirim_terakhir: "", status_koneksi: "")
    
    static var previews: some View {
        vmsModal(dataResult: sendDataVms)
    }
}

struct CardShimmerVms: View {
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
