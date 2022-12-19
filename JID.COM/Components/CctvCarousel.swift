//
//  CctvCarousel.swift
//  JID.COM
//
//  Created by Panda on 29/11/22.
//

import SwiftUI

struct CctvCarousel: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isShowCctv : Bool
    @Binding var idruas : Int
    @State var urlSet : String = ""
    @State var stopRun: Bool = true
    
    @State var datacctvbyruas : [GetcctvByruas] = []
    
    var body: some View {
        if isShowCctv {
            VStack{
                if datacctvbyruas.isEmpty {
                    Text("Loading Data ...")
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.white)
                        .cornerRadius(10)
                }else{
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(datacctvbyruas) { result in
                                Spacer()
                                VStack{
                                    VStack(alignment: .leading, spacing: 0){
                                        AsyncImage(url: URL(string: urlSet)) { phase in
                                            if let image = phase.image {
                                                image
                                                    .resizable()
                                            } else if phase.error != nil {
                                                CardShimmerCctv()
                                            } else {
                                                CardShimmerCctv()
                                            }
                                        }
                                        .frame(height: 250)
                                        .background(Color.white)
                                        
                                        HStack{
                                            Image("logocctv")
                                            VStack(alignment: .leading){
                                                Text("Lokasi")
                                                    .font(.system(size: 13))
                                                    .foregroundColor(Color.white.opacity(0.50))
                                                Text(result.nama)
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
                                        Text("Nama Cabang")
                                            .font(.system(size: 13))
                                            .foregroundColor(Color.black.opacity(0.50))
                                        Text(result.cabang)
                                            .font(.system(size: 16))
                                            .foregroundColor(Color.black)
                                            .padding(.top, 2)
                                            .multilineTextAlignment(.center)
                                        
                                        Button("Putar CCTV") {
                                            startRunSnap(keyid: result.key_id)
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
                                Spacer()
                            }
                        }
                        .padding(.bottom, 20)
                        
                    }
                    .onTapGesture{
                        print("Sas sassa")
                    }
                    
                    Button{
                        stopRun = true
                        isShowCctv = false
                    }label: {
                        Text("TUTUP")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.white)
                            .cornerRadius(10)
                    }
                }
                
            }
            .onAppear{
                ListCctvModel().getCctvByruas(idruas: idruas){ (resultcctv) in
                    datacctvbyruas = resultcctv
                }
            }
            
        }
    }
    
    private func startRunSnap(keyid: String) {
       Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
           urlSet = "https://jid.jasamarga.com/cctv2/\(keyid)?tx=\(Float.random(in: 0...1))"
           print(urlSet)
           if stopRun == false {
               timer.invalidate()
               print("stop...")
           }
        }
    }
    
}

struct CctvCarousel_Previews: PreviewProvider {
    static var previews: some View {
        CctvCarousel(isShowCctv: .constant(true), idruas: .constant(0))
    }
}


struct CardShimmerCctv: View {
    
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
//            withAnimation(Animation.default.speed(0.35).delay(0).repeatForever(autoreverses: false)){
//                self.show.toggle()
//            }
        }
    }
}
