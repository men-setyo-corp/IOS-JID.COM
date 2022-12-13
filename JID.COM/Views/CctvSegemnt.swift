//
//  CctvSegemnt.swift
//  JID.COM
//
//  Created by Macbook on 27/09/22.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct CctvSegemnt: View {
    var writer: Writer
    @Environment(\.presentationMode) var presentationMode
    @StateObject var modelListcctv : ListCctvModel = ListCctvModel()
    @State var datacctv : [Getcctv] = []
    
    @State var stopRun: Bool = true;
    @State var urlStreamImg = URL(string: "")
    @State var urlStreamImgNil = URL(string: "")
    @State var urlSet = ""
    @State var namaSet = ""
    @State var selectedCard: Bool = true;
    @State var keyStream = ""
    @State var selectedIndex: Int = 0
    @State var errShow: Bool = false;
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button{
                        stopRun = false
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
                        Text(writer.nama_ruas != "" ? writer.nama_ruas : "nama segment")
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
                            AsyncImage(url: URL(string:urlSet)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                } else if phase.error != nil {
                                    CardShimmerImg()
                                } else {
                                    CardShimmerImg()
                                }
                            }
                        }
                        .onAppear{
                            startRun()
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .frame(height: 250, alignment: .center)
                .background(Color(.white))
                .cornerRadius(10)
                .padding(.top, 10)
                .shadow(radius: 2)
                .padding(.horizontal, 25)
                
                
                Text("Lokasi")
                    .foregroundColor(Color(UIColor(hexString: "#818181")))
                    .padding(.top, 4)
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Text(namaSet.isEmpty ? "Loading...":namaSet)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                }
                .padding(.top, 1)
                .redacted(reason: datacctv.isEmpty ? .placeholder : [])
                
                ZStack{
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(datacctv){ row in
                                Button{
                                    selectedIndex = row.id
                                    keyStream = row.key_id
                                    namaSet = row.nama
                                }label:{
                                    ZStack{
                                        VStack{
//                                            ZStack{
//                                                Image("cctv_icon")
//                                                    .data(url: "https://jid.jasamarga.com/cctv2/\(row.key_id)?tx=\(Float.random(in: 5...20))")
//                                                    .clipped()
//                                            }
//                                            .frame(width: 200, height: 150)
//                                            AsyncImage(url: URL(string: "https://jid.jasamarga.com/cctv2/\(row.key_id)?tx=\(Float.random(in: 5...20))")) { phase in
//                                                if let image = phase.image {
//                                                    image
//                                                        .resizable()
//                                                        .frame(width: 200, height: 150)
//                                                } else if phase.error != nil {
//                                                    CardShimmerImgSmall()
//                                                } else {
//                                                    ProgressView()
//                                                }
//                                            }
//                                            .background(Color.white)
                                            
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
                                                .padding(.top, 5)
                                                .padding(.bottom, 10)
                                            }
                                            .frame(width: 200)
                                            .redacted(reason: row.nama.isEmpty ? .placeholder : [])
                                        }
                                    }
                                    .frame(alignment: .center)
                                    .background(selectedIndex == row.id ? Color(UIColor(hexString: "#DFEFFF")) : Color.white)
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
            ListCctvModel().getCctv(idruas: writer.id_key, idsegment: writer.id_segment){ (resultcctv) in
                self.datacctv = resultcctv
                if let valueFirst = datacctv.first {
                    urlSet = "https://jid.jasamarga.com/cctv2/\(valueFirst.key_id)?tx=\(Float.random(in: 0...1))"
                    namaSet = valueFirst.nama
                    urlStreamImg = URL(string: urlSet)
                    keyStream = valueFirst.key_id
                    selectedIndex = valueFirst.id
                }
            }
        }
        .alert("Important message", isPresented: $modelListcctv.showErr) {
            Button("OK", role: .cancel) { }
        }
        
    }
    
    private func startRun() {
       Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
           urlSet = "https://jid.jasamarga.com/cctv2/\(keyStream)?tx=\(Float.random(in: 0...1))"
           if stopRun == false {
               timer.invalidate()
               print("stop..")
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
        nama_ruas: ""
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
