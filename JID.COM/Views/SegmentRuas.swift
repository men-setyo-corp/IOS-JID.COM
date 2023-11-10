//
//  SegmentRuas.swift
//  JID.COM
//
//  Created by Macbook on 20/09/22.
//

import SwiftUI

struct SegmentRuas: View {
    var writer: Writer
    
    @Environment(\.presentationMode) var presentationMode
    @State var search = ""
    @State var nulldata = ""
    
    @State var datasegment : [Getsegment] = []
    
    var items: [GridItem] {
      Array(repeating: .init(.adaptive(minimum: 120)), count: 1)
    }
    
    var body: some View {
        ZStack {
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
                    VStack{
                        Text("Ruas")
                            .foregroundColor(Color(UIColor(hexString: "#818181")))
                            .font(.system(size: 15))
                            .padding(.bottom, 1)
                        Text(writer.nama_ruas != "" ? writer.nama_ruas : "nama ruas")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.horizontal,10)
                
                ZStack{
                    TextField("cari segment", text: $search)
                        .padding(10)
                        .padding(.horizontal, 25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                        )
                        .background{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white.opacity(0.05))
                        }
                        .foregroundColor(Color.black)
                        .textInputAutocapitalization(.never)
                        .font(.system(size: 17))
                        .overlay(
                            HStack{
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 10)
                                    .font(.system(size: 16))
                            }
                        )
                        .padding(.bottom, 10)
                        .searchable(text: $search)
                }
                .padding(.horizontal, 10)
                
                ScrollView{
                    let parseKey = Writer(
                        id_key: writer.id_key,
                        id_segment: 0,
                        nama_ruas: "Semua Segment"
                    )
                    NavigationLink(
                        destination: CctvSegemnt(writer: parseKey),
                    label:{
                        HStack{
                            ZStack{
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(UIColor(hexString: "#390099")))
                            }
                            .padding(7)
                            .background(Color(UIColor(hexString: "#DFEFFF")))
                            .clipShape(Circle())
                            
                            Spacer()
                            Text("SEMUA SEGMENT")
                                .font(.system(size:12, weight: .bold))
                                .foregroundColor(Color(UIColor(hexString: "#390099")))
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                        .padding(.vertical, 15)
                        .padding(.horizontal, 15)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                        )
                        .background{
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.08))
                        }
                        .cornerRadius(16)
                        .padding(.top, 10)
                        .shadow(radius: 2)
                    })
                    
//                    LazyVGrid(columns: items, spacing: 5) {
//                    }
//                    .padding(.bottom, 10)
//                    .padding(.horizontal, 25)
                    
                    if searchResults.isEmpty {
                        if nulldata == "kosong" {
                            Text("Silahkan pilih semua segment !")
                                .foregroundColor(Color.gray)
                                .padding(.vertical)
                        }else{
                            ForEach(1..<10){row in
                                CardShimmerSegment()
                            }
                        }
                    }else{
                        ForEach(searchResults) { row in
                            let parseKey = Writer(
                                id_key: row.id_ruas,
                                id_segment: row.idx,
                                nama_ruas: row.nama_segment
                            )
                            NavigationLink(
                                destination: CctvSegemnt(writer:parseKey),
                            label:{
                                HStack{
                                    ZStack{
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(Color(UIColor(hexString: "#390099")))
                                    }
                                    .padding(7)
                                    .background(Color(UIColor(hexString: "#DFEFFF")))
                                    .clipShape(Circle())
                                    
                                    Spacer()
                                    Text(row.nama_segment)
                                        .font(.system(size:12))
                                        .foregroundColor(Color(UIColor(hexString: "#390099")))
                                        .multilineTextAlignment(.center)
                                    Spacer()
                                }
                                .padding(.vertical, 15)
                                .padding(.horizontal, 15)
                                .frame(maxWidth: .infinity)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                                )
                                .background{
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.white.opacity(0.08))
                                }
                                .cornerRadius(16)
                                .padding(.top, 10)
                                .shadow(radius: 2)
                            })
                        }
                    }
                    
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 5)
                
                Spacer()
            }
            .padding(.horizontal)
            .background(.white)
        }
        .background(.white)
        .navigationBarHidden(true)
        .onAppear{
            SegmentModel().getSegment(idruas: writer.id_key){ (data) in
                if data.isEmpty{
                    self.nulldata = "kosong"
                }else{
                    self.datasegment = data
                }
            }
        }
    }
    
    var searchResults: [Getsegment] {
        if search.isEmpty {
            return self.datasegment
        } else {
            return self.datasegment.filter { $0.nama_segment.localizedStandardContains(search) }
        }
    }
}

struct CardShimmerSegment: View {
    
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body: some View{
        ZStack{
            Color.black.opacity(0.09)
            .frame(height:150)
            .cornerRadius(10)
            
            Color.white
            .frame(height:150)
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

struct SegmentRuas_Previews: PreviewProvider {
    static let writerPreview = Writer(
        id_key: 0,
        id_segment: 0,
        nama_ruas: ""
    )
    
    static var previews: some View {
        SegmentRuas(writer: writerPreview)
    }
}
