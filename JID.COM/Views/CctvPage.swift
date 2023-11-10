//
//  CctvPage.swift
//  JID.COM
//
//  Created by Macbook on 15/09/22.
//

import SwiftUI
import SwiftyJSON

struct CctvPage: View {
    
    @StateObject var modelLogin : LoginModel = LoginModel()
    @State var search = ""
    @State var stoprun = true
    @State var dataruas : [Getruas] = []
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    ZStack{
                        TextField("Cari ruas", text: $search)
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
                            .foregroundColor(.gray)
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
                    .background(.white)
                 
                    ScrollView{
                        if self.dataruas.isEmpty {
                            ForEach(0...10,id: \.self){_ in
                                CardShimmer()
                            }
                        }else{
                            if searchResults.isEmpty {
                                VStack{
                                    Spacer()
                                    Text("Maaf, ruas tidak ditemukan...")
                                        .foregroundColor(.init(white:0.7))
                                    Spacer()
                                }
                            }else{
                                ForEach(searchResults) { result in
                                    let parseKey = Writer(
                                        id_key: result.id_ruas,
                                        id_segment: 0,
                                        nama_ruas: result.nama_ruas
                                    )
                                    NavigationLink(
                                        destination: SegmentRuas(writer: parseKey),
                                    label:{
                                        HStack{
//                                            VStack(alignment: .leading){
//                                                Text(result.nama_ruas_2)
//                                                    .font(.system(size: 20, weight: .bold))
//                                                    .foregroundColor(.black)
//                                                Text(result.nama_ruas)
//                                                    .font(.system(size: 12, weight:.bold))
//                                                    .foregroundColor(.black)
//                                                    .multilineTextAlignment(.leading)
//                                            }
//                                            .padding(10)
//                                            .foregroundColor(.white)
                                            Spacer()
                                            Text(result.nama_ruas)
                                                .font(.system(size: 12, weight:.bold))
                                                .foregroundColor(.black)
                                                .multilineTextAlignment(.center)
                                            Spacer()
                                            
                                            NavigationLink(
                                                destination: MapPage(showCarousel: true, idruas: result.id_ruas, stopRun: stoprun),
                                            label:{
                                                Image(systemName: "map")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(Color(UIColor(hexString: "#390099")))
                                            })
                                            .padding(7)
                                            .background(Color(UIColor(hexString: "#DFEFFF")))
                                            .clipShape(Circle())
                                            .shadow(radius: 2)
                                            .accentColor(.black)
                                          
//                                            ZStack{
//                                                HStack{
//                                                    Spacer()
//                                                    NavigationLink(
//                                                        destination: MapPage(),
//                                                    label:{
//                                                        Image(systemName: "map")
//                                                            .font(.system(size: 18))
//                                                            .foregroundColor(Color(UIColor(hexString: "#390099")))
//                                                    })
//                                                    .padding(7)
//                                                    .background(Color(UIColor(hexString: "#DFEFFF")))
//                                                    .clipShape(Circle())
//                                                    .shadow(radius: 2)
//                                                }
//                                            }
//                                            .padding(.horizontal)
//                                            .padding(.vertical)
                                            
                                        }
                                        .padding(15)
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
                                        .shadow(radius: 5)
                                    })
                                   
                                }
                            }
                            
                        }
                    }
                    .padding(.horizontal, 10)
                    .background(.white)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .background(.white)
            }
            .padding(.top, 15)
            .onAppear{
                Ruasmodel().getRuas{ (parsedata) in
                    self.dataruas = parsedata
                }
            }
            .navigationBarHidden(true)
            .background(.white)
            //end zstack
        }
        
        //end navigation view
    }
    
    var searchResults: [Getruas] {
        if search.isEmpty {
            return self.dataruas
        } else {
            return self.dataruas.filter { $0.nama_ruas.localizedStandardContains(search) }
        }
    }
    
}

struct CctvPage_Previews: PreviewProvider {
    static var previews: some View {
        CctvPage()
    }
}

struct CardShimmer: View {
    
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body: some View{
        ZStack{
            Color.black.opacity(0.09)
            .frame(height:150)
            .cornerRadius(16)
            
            Color.white
            .frame(height:150)
            .cornerRadius(16)
            .mask(
                Rectangle()
                .fill(
                    LinearGradient(gradient: .init(colors: [.clear, Color.white.opacity(0.18)]), startPoint: .top, endPoint: .bottom)
                )
                .rotationEffect(.init(degrees: 70))
                .offset(x: self.show ? center: -center)
            )
        }
        .padding(.top, 10)
        .onAppear{
            withAnimation(Animation.default.speed(0.35).delay(0).repeatForever(autoreverses: false)){
                self.show.toggle()
            }
        }
    }
}

extension View {
    public var backgroundImage: some View {
        ZStack {
            Image("tol_photo")
                .resizable()
                .aspectRatio(contentMode: .fill)
            LinearGradient(
                gradient: Gradient(colors: [Color(white: 0, opacity: 0.70), .clear]),
                startPoint: .topLeading,
                endPoint: UnitPoint(x: 10, y: 10)
            )
        }
    }
}

