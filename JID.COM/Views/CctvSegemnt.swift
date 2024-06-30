//
//  CctvSegemnt.swift
//  JID.COM
//
//  Created by Macbook on 27/09/22.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI
import AVKit

struct CctvSegemnt: View {
    var writer: Writer
    @Environment(\.presentationMode) var presentationMode
    @StateObject var modelListcctv : ListCctvModel = ListCctvModel()
    @State var datacctv : [Getcctv] = []
    @State var datacctvnonjm : [Getcctvsnonjm] = []
    
    @State var stopRun: Bool = false;
    @State var urlStreamImg = ""
    @State var urlStreamHls = ""
    @State var urlSet = ""
    @State var urlSetDef = ""
    @State var namaSet = ""
    @State var namaSegmentSet = ""
    @State var is_hls: Bool = true
    @State var selectedCard: Bool = true;
    @State var keyStream = ""
    @State var selectedIndex: Int = 0
    @State var selectedCctv: String = ""
    @State var errShow: Bool = false;
    @State var playerHls = AVPlayer()
    @State var controlPlay = AVPlayerViewController()
    @State var playerItem:AVPlayerItem?
    @State var timeObserver: Any?
    @State var timerRunImg: Timer? = nil
    @State var showLoadingHsl: Bool = true
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button{
                        stopRun = true
                        timerRunImg?.invalidate()
                        timerRunImg = nil
                        self.presentationMode.wrappedValue.dismiss()
                    }label:{
                        Text(Image(systemName: "chevron.backward"))
                            .foregroundColor(Color(UIColor(hexString: "#323232")))
                            .font(.system(size: 20, weight: .bold))
                    }
                    Spacer()
                    VStack{
                        Text("Segment")
                            .foregroundColor(Color(UIColor(hexString: "#818181")))
                            .font(.system(size: 15))
                            .padding(.bottom, 1)
                        Text(writer.id_segment != 0 ? writer.nama_segment : "Semua Segment")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal,25)
                
                ZStack{
                    if urlSet.isEmpty {
                        CardShimmerImg()
                    }else{
                        VStack{
                            if is_hls {
                                VideoPlayer(player: playerHls)
                                    .onAppear(){
                                        controlPlay.player = playerHls
                                        controlPlay.showsPlaybackControls = false
                                        controlPlay.videoGravity = .resizeAspectFill
                                    }
                                    .onDisappear(){
                                        playerHls.pause()
                                    }
                            }else{
                                AsyncImage(url: URL(string:urlSet)) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .onAppear{
                                                startRun()
                                            }
                                    } else if phase.error != nil {
                                        ProgressView()
                                            .tint(.white)
                                            .onAppear(){
                                                stopRun = true
                                                timerRunImg?.invalidate()
                                                timerRunImg = nil
                                            }
                                            .onChange(of: stopRun){ val in
                                                if val == true {
                                                    startRun()
                                                }
                                            }
                                    } else {
                                        ProgressView()
                                            .tint(.white)
                                            .onAppear(){
                                                stopRun = true
                                                timerRunImg?.invalidate()
                                                timerRunImg = nil
                                            }
                                            .onChange(of: stopRun){ val in
                                                if val == true {
                                                    startRun()
                                                }
                                            }
                                    }
                                }
                            }
                        }
                        if is_hls {
                            ZStack{
                                if showLoadingHsl {
                                    VStack{
                                        Spacer()
                                        ProgressView()
                                            .tint(.white)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 250, alignment: .center)
                .background(Color(.black))
                .cornerRadius(10)
                .padding(.top, 10)
                .shadow(radius: 2)
                .padding(.horizontal, 25)
                
                Text("Lokasi")
                    .foregroundColor(Color(UIColor(hexString: "#818181")))
                    .padding(.top, 4)
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Text("\(namaSet) | \(namaSegmentSet)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 1)
                .padding(.horizontal,15)
                .redacted(reason: datacctv.isEmpty ? .placeholder : [])
                
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(datacctv, id: \.key_id){ row in
                                Button{
                                    showLoadingHsl = true
                                    urlStreamImg = "https://jid.jasamarga.com/cctv2/\(row.key_id)?tx=\(Float.random(in: 0...1))"
                                    urlStreamHls = "https://jmlive.jasamarga.com/hls/"+row.id_ruas+"/"+row.key_id+"/index.m3u8"
                                    is_hls = row.is_hls
                                    if row.is_hls {
                                        urlSet = urlStreamHls
                                        playerItem = AVPlayerItem(url: URL(string: urlSet)!)
                                        playerHls = AVPlayer(playerItem: playerItem)
                                        playerHls.replaceCurrentItem(with: playerItem)
                                        
                                        playerHls.play()
                                        
                                        playerHls.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { (CMTime) -> Void in
                                           
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
                                      
                                        bufferHandle()
                                    }else{
                                        urlSet = urlStreamImg
                                    }
                                    selectedCctv = row.nama
                                    selectedIndex = row.id
                                    keyStream = row.key_id
                                    namaSet = row.nama
                                    namaSegmentSet = row.nama_segment
                                }label:{
                                    ZStack{
                                        VStack{
                                            ZStack{
                                                HStack{
                                                    Image("cctv_icon")
                                                        .font(.system(size: 35, weight: .bold))
                                                        .foregroundColor(Color(UIColor(hexString: "#390099")))
                                                }
                                                .padding(25)
                                                .background(Color(UIColor(hexString: "#DFEFFF")))
                                                .clipShape(Circle())
                                            }
                                            .padding(.top, 20)
                                            
                                            ZStack{
                                                VStack{
                                                    Text("\(row.nama)")
                                                        .font(.system(size: 10))
                                                        .foregroundColor(Color.black)
                                                    Text(row.nama_segment)
                                                        .padding(.top, 1)
                                                        .font(.system(size: 10))
                                                        .foregroundColor(Color.black)
                                                }
                                                .padding(.horizontal, 10)
                                                .padding(.top, 5)
                                                .padding(.bottom, 10)
                                            }
                                            .frame(width: 200)
                                            .redacted(reason: row.nama.isEmpty ? .placeholder : [])
                                        }
                                    }
                                    .frame(alignment: .center)
                                    .background(selectedCctv == row.nama ? Color(UIColor(hexString: "#DFEFFF")) : Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 2)
                                }
                                
                            }
                        }
                        .padding(.horizontal, 5)
                        .padding(.vertical, 10)
                    }
                    .transition(.move(edge: .bottom))
                    .ignoresSafeArea()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()
            }
        }
        .background(.white)
        .navigationBarHidden(true)
        .onAppear{
            ListCctvModel().getCctv(idruas: writer.id_key, nama_segment: writer.nama_segment){ (resultcctv) in
                self.datacctv = resultcctv
               
                if let valueFirst = datacctv.first {
                    urlStreamImg = "https://jid.jasamarga.com/cctv2/\(valueFirst.key_id)?tx=\(Float.random(in: 0...1))"
                    urlStreamHls = "https://jmlive.jasamarga.com/hls/"+valueFirst.id_ruas+"/"+valueFirst.key_id+"/index.m3u8"
                    if valueFirst.is_hls {
                        showLoadingHsl = true
                        
                        urlSet = urlStreamHls
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
                        bufferHandle()
                    }else{
                        urlSet = urlStreamImg
                    }
                    
                    namaSet = valueFirst.nama
                    namaSegmentSet = valueFirst.nama_segment
                   
                    keyStream = valueFirst.key_id
                    selectedIndex = valueFirst.id
                    selectedCctv = valueFirst.nama
                    is_hls = valueFirst.is_hls
                }
            }
        }
        .alert("Important message", isPresented: $modelListcctv.showErr) {
            Button("OK", role: .cancel) { }
        }
        
    }
    
    private func startRun() {
        timerRunImg = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { timer in
            urlSet = "https://jid.jasamarga.com/cctv2/\(keyStream)?tx=\(Float.random(in: 0...1))"
            if stopRun == true {
                timerRunImg?.invalidate()
                timerRunImg = nil
                print("stop..")
            }
        }
    }
    
    private func bufferHandle() {
        // Delay of 7 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            if showLoadingHsl {
                print("buffer selama 7 detik")
                urlSet = urlStreamImg
                is_hls = false
            }else{
                urlSet = urlStreamHls
                is_hls = true
            }
        }
    }
    
    
}

struct CardShimmerImg: View {
    
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body: some View{
        ZStack{
            Color.black.opacity(0.09)
            .cornerRadius(10)
            
            Color.white
            .cornerRadius(10)
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

struct CardShimmerImgSmall: View {
    
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body: some View{
        ZStack{
            Color.black.opacity(0.09)
            .frame(width: 200, height: 150)
            
            Color.white
            .frame(width: 200, height: 150)
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

struct CctvSegemnt_Previews: PreviewProvider {
    static let writerPreview = Writer(
        id_key: 0,
        id_segment: 0,
        nama_segment: ""
    )
    
    static var previews: some View {
        CctvSegemnt(writer: writerPreview)
    }
}

extension Image{
    func data(url: String) -> Self {
        if let data  = try? Data(contentsOf: URL(string: url)!){
            return Image(uiImage: UIImage(data: data)!)
                .resizable()
        }
        return self
            .resizable()
    }
}
