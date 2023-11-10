//
//  SnapImgSingle.swift
//  JID.COM
//
//  Created by Macbook on 29/09/22.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImage

struct SnapImgSingle: View {
    @Environment(\.presentationMode) var presentationMode
    
    var dataSnap : Data_cctv
    @State var urlSet : String = ""
    @State var stopRun: Bool = true
    
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 0){
                AsyncImage(url: URL(string: urlSet)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                    } else if phase.error != nil {
                        ProgressView()
                    } else {
                        CardShimmerSnap()
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 250)
                .background(Color.white)
                
                HStack{
                    Image("logocctv")
                    VStack(alignment: .leading){
                        Text("Lokasi")
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.50))
                        Text(dataSnap.nama)
                            .font(.system(size: 15))
                            .foregroundColor(Color.white)
                    }
                    Spacer()
                }
                .frame(alignment: .leading)
                
            }
            .background(Color(UIColor(hexString: "#344879")))
            .cornerRadius(20)
            
            VStack{
                Text("Ruas Tol")
                    .font(.system(size: 13))
                    .foregroundColor(Color.black.opacity(0.50))
                Text(dataSnap.nama_ruas)
                    .font(.system(size: 16))
                    .foregroundColor(Color.black)
                    .padding(.top, 2)
                    .multilineTextAlignment(.center)
                
                Button("Tutup") {
                    stopRun = false
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color.red)
                .font(.system(size: 14))
                .padding(.top, 4)
            }
            .padding(.top, 13)
        }
        .frame(width: 310)
        .padding(15)
        .background(Color.white)
        .cornerRadius(20)
        .onAppear{
            startRunSnap()
        }
        
    }
    
    private func startRunSnap() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
           urlSet = "https://jid.jasamarga.com/cctv2/\(dataSnap.key_id)?tx=\(Float.random(in: 0...1))"
           
           if stopRun == false {
               timer.invalidate()
               print("stop...")
           }
        }
    }
    
}

struct SnapImgSingle_Previews: PreviewProvider {
    
    static let dataSendSnap = Data_cctv(title: "", id_ruas: 0, nama_ruas: "", nama_ruas_2: "", nama: "", status: "", km: "", key_id: "", arteri: 0)
    
    static var previews: some View {
        SnapImgSingle(dataSnap: dataSendSnap)
    }
}


struct CardShimmerSnap: View {
    
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
