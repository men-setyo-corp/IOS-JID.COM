//
//  SnapImage.swift
//  JID.COM
//
//  Created by Macbook on 29/09/22.
//

import SwiftUI

struct SnapImage: View {
    
    var body: some View {
        Carausel3()
    }
}


struct Carausel3: View {
 
    var colors: [Color] = [ .orange, .green, .yellow, .pink, .purple ]
    var emojis: [String] = [ "👻", "🐱", "🦊" , "👺", "🎃"]
    @State private var indeSelected = 0
 
    var body: some View {
        VStack(spacing: 15){
            Text("\(indeSelected)")
            TabView(selection: $indeSelected) {
                ForEach(0..<Int(emojis.endIndex), id: \.self) { index in
                    viewCard()
                        .tabItem {
                            Text(emojis[index])
                        }
                }
     
            }
            .frame(height: 450)
            .tabViewStyle(PageTabViewStyle())
           
        }
    }
}

struct viewCard: View{
    var body: some View{
        VStack{
            VStack(alignment: .leading, spacing: 0){
                AsyncImage(url: URL(string: "urlSet")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                    } else if phase.error != nil {
                        CardShimmerSnap()
                    } else {
                        CardShimmerSnap()
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
                        Text("dataSnap.nama")
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
                Text("dataSnap.nama_ruas")
                    .font(.system(size: 16))
                    .foregroundColor(Color.black)
                    .padding(.top, 2)
                
                Button("Keluar") {
//                    stopRun = false
//                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color.red)
                .font(.system(size: 14))
                .padding(.top, 4)
            }
            .padding(.top, 13)
            
        }
        .frame(width: 310)
        .padding(15)
        .background(Color.red)
        .cornerRadius(20)
        .onAppear{
            
        }
    }
}

struct SnapImage_Previews: PreviewProvider {
    static var previews: some View {
        SnapImage()
    }
}
