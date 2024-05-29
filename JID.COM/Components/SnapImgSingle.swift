//
//  SnapImgSingle.swift
//  JID.COM
//
//  Created by Macbook on 29/09/22.
//

import SwiftUI
import SDWebImageSwiftUI
import SDWebImage
import AVFoundation
import AVKit

struct SnapImgSingle: View {
    @Environment(\.presentationMode) var presentationMode
    
    var dataSnap : Data_cctv
    @State var urlSet : String = ""
    @State var urlStreamImg = ""
    @State var urlStreamHls = ""
    @State var stopRun: Bool = false
    @State var playerHls = AVPlayer()
    @State var playerItem:AVPlayerItem?
    @State var timer: Any?
    @State var showLoadingHsl: Bool = true
    @State var is_hls: Bool = true
    
    var body: some View {
        VStack{
            VStack(alignment: .leading, spacing: 0){
                if is_hls {
                    ZStack{
                        VideoPlayer(player: playerHls)
                            .onAppear(){
                                let control = AVPlayerViewController()
                                control.player = playerHls
                                control.showsPlaybackControls = false
                                control.videoGravity = .resizeAspectFill
                                
                                playerItem = AVPlayerItem(url: URL(string: urlSet)!)
                                playerHls = AVPlayer(playerItem: playerItem)
                                playerHls.replaceCurrentItem(with: playerItem)
                                
                                playerHls.play()
                                playerHls.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main){ (CMTime) -> Void in
                                    
                                    if playerHls.currentItem?.status == .readyToPlay {
                                        playerHls.play()
                                    }
                                    let playbackLikelyToKeepUp = playerHls.currentItem?.isPlaybackLikelyToKeepUp
                                    if playbackLikelyToKeepUp == false{
                                        print("IsBuffering")
                                        showLoadingHsl = true
                                    } else {
                                        showLoadingHsl = false
                                    }
                                }
                            }
                            .onDisappear(){
                                playerHls.pause()
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 250)
                        if showLoadingHsl {
                            ProgressView()
                                .tint(.white)
                        }
                    }
                    
                }else{
                    AsyncImage(url: URL(string: urlSet)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .onAppear{
                                    startRunSnap()
                                }
                        } else if phase.error != nil {
                            ProgressView()
                                .tint(.white)
                        } else {
                            ProgressView()
                                .tint(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 250)
                    .background(Color.black)
                }
                
                
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
            .onAppear(){
                urlStreamImg = "https://jid.jasamarga.com/cctv2/\(dataSnap.key_id)?tx=\(Float.random(in: 0...1))"
                urlStreamHls = "https://jmlive.jasamarga.com/hls/\(dataSnap.id_ruas)/\(dataSnap.key_id)/index.m3u8"
                is_hls = dataSnap.is_hls
                if is_hls {
                    urlSet = urlStreamHls
                }else{
                    urlSet = urlStreamImg
                }
                bufferHandle()
            }
            .onChange(of: is_hls){val in
                startRunSnap()
            }
            
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
                    stopRun = true
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
        
    }
    
    private func startRunSnap() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            urlSet = "https://jid.jasamarga.com/cctv2/\(dataSnap.key_id)?tx=\(Float.random(in: 0...1))"
            
           if stopRun == true {
               timer.invalidate()
               print("stop...")
           }
        }
    }
    
    private func bufferHandle() {
        // Delay of 7 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            if showLoadingHsl {
                print("buffer selama 7 detik")
                urlSet = urlStreamHls
                is_hls = false
                showLoadingHsl = false
            }else{
                urlSet = urlStreamImg
                is_hls = true
            }
        }
    }
    
}

struct SnapImgSingle_Previews: PreviewProvider {
    
    static let dataSendSnap = Data_cctv(title: "", id_ruas: 0, nama_ruas: "", nama_ruas_2: "", nama: "", status: "", km: "", key_id: "", arteri: 0, is_hls: true)
    
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
