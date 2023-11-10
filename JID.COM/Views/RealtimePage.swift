//
//  RealtimePage.swift
//  JID.COM
//
//  Created by Panda on 07/11/22.
//

import SwiftUI

struct RealtimePage: View {
    @State var showLoading: Bool = false
    var baseUrl = "https://jid.jasamarga.com/graph/"
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("Realtime Traffic")
                    .foregroundColor(Color(UIColor(hexString: "#323232")))
                    .font(.system(size: 20, weight: .bold))
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.bottom, 15)
            Spacer()
            ZStack{
                WebView(url: URL(string: baseUrl+"realtime_lalin/mobile")!, showLoading: $showLoading)
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

struct RealtimePage_Previews: PreviewProvider {
    static var previews: some View {
        RealtimePage()
    }
}
