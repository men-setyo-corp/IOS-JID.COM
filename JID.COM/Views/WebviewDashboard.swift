//
//  WebviewDashboard.swift
//  JID.COM
//
//  Created by Macbook on 22/09/22.
//

import SwiftUI

extension View{
    func toAnyView() -> AnyView{
        AnyView(self)
    }
}

struct WebviewDashboard: View {
    
    @Environment(\.presentationMode) var presentationMode
    var baseUrl = "https://jid.jasamarga.com/dashboard/"
    @State var urlweb : String
    @State var title : String
    @State var showLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack{
                ZStack{
                    WebView(url: URL(string: baseUrl+urlweb)!, showLoading: $showLoading)
                        .background(Color.white)
                        .overlay(showLoading ? ProgressView("Loading...")
                            .tint(Color.black)
                            .foregroundColor(Color.black)
                            .toAnyView() : EmptyView().toAnyView())
                }
                .background(.white)
                
            }
            .background(.white)
        }
        .onAppear{
            self.showLoading.toggle()
        }
        .navigationBarHidden(true)
        .background(.white)
    }
}

struct WebviewDashboard_Previews: PreviewProvider {
    static var previews: some View {
        WebviewDashboard(urlweb: "", title: "")
    }
}

struct CardLoadingWebview: View {
    
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 210
    
    var body: some View{
        ZStack{
            Color.black.opacity(0.09)
            .cornerRadius(16)
            
            Color.white
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
        .onAppear{
            withAnimation(Animation.default.speed(0.35).delay(0).repeatForever(autoreverses: false)){
                self.show.toggle()
            }
        }
    }
}
