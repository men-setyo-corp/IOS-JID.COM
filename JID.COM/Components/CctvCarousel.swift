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
    @State var keyStream : String = ""
    @State var nmKm : String = ""
    @Binding var stopRun: Bool
    
    @State var datacctvbyruas : [GetcctvByruas] = []
    
    var body: some View {
        if isShowCctv {
            VStack{
                HStack{
                    Button{
                        stopRun = false
                        self.presentationMode.wrappedValue.dismiss()
                    }label:{
                        Image(systemName: "chevron.backward")
                            .foregroundColor(Color(UIColor(hexString: "#323232")))
                            .font(.system(size: 20, weight: .bold))
                    }
                    .padding(.horizontal,10)
                    .padding(.vertical, 7)
                    .background(.white)
                    .cornerRadius(100)
                    .shadow(radius: 2)
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.horizontal,25)
                Spacer()
                
                VStack{
                    if datacctvbyruas.isEmpty {
                        Spacer()
                        Text("Loading Data ...")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.white)
                            .cornerRadius(10)
                        Spacer()
                    }else{
                        VStack{
                            Text(nmKm == "" ? "KM 0 + 000" : nmKm)
                                .font(.system(size: 20, weight: .black))
                                .foregroundColor(.black)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 7)
                                .background(.white)
                                .cornerRadius(5)
                                .shadow(radius: 2)
                            
                            AsyncImage(url: URL(string: urlSet)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                } else if phase.error != nil {
                                    CardShimmerImg()
                                } else {
                                    CardShimmerImg()
                                }
                            }
                            .frame(height: 250)
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 25)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack{
                                ForEach(datacctvbyruas) { result in
                                    Spacer()
                                    VStack{
                                        VStack(alignment: .leading, spacing: 0){
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
                                            
                                            Button{
                                                nmKm = result.nama
                                                keyStream = result.key_id
                                                startRunSnap()
                                            }label: {
                                                Image(systemName: "play.rectangle.fill")
                                                    .font(.system(size: 25))
                                                    .foregroundColor(.gray)
                                            }
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
                        
                        Button{
                            stopRun = false
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
                        if let valueFirst = datacctvbyruas.first {
                            nmKm = valueFirst.nama
                            keyStream = valueFirst.key_id
                            startRunSnap()
                        }
                    }
                }
                
            }
            .navigationBarBackButtonHidden(true)
            
        }
    }
    
    private func startRunSnap() {
       Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
           urlSet = "https://jid.jasamarga.com/cctv2/\(keyStream)?tx=\(Float.random(in: 0...1))"
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
        CctvCarousel(isShowCctv: .constant(true), idruas: .constant(0), stopRun: .constant(true))
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
