//
//  AntrianPage.swift
//  JID.COM
//
//  Created by Panda on 07/11/22.
//

import SwiftUI

struct AntrianPage: View {
    @State var showLoading: Bool = false
    var baseUrl = "https://jid.jasamarga.com/dashboard/"
    
    var body: some View {
        VStack{
//            HStack{
//                Spacer()
//                Text("Antrian Gerbang")
//                    .foregroundColor(Color(UIColor(hexString: "#323232")))
//                    .font(.system(size: 20, weight: .bold))
//                Spacer()
//            }
//            .padding(.horizontal, 25)
//            .padding(.bottom, 15)
//            Spacer()
            ZStack{
                WebView(url: URL(string: baseUrl+"lalin/antrian-gerbang")!, showLoading: $showLoading)
                    .overlay(showLoading ? ProgressView("Loading...").toAnyView() : EmptyView().toAnyView())
            }
            
        }
        .onAppear{
            self.showLoading.toggle()
        }
        .navigationBarHidden(true)
        .background(.white)
    }
}

struct AntrianPage_Previews: PreviewProvider {
    static var previews: some View {
        AntrianPage()
    }
}
