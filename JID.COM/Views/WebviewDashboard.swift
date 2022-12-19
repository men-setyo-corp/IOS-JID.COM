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
    var baseUrl = "https://jid.jasamargalive.com/graph/"
    @State var urlweb : String
    @State var title : String
    @State var showLoading: Bool = false
    
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
                    
                    Text(title.replacingOccurrences(of: "\n", with: " "))
                        .foregroundColor(Color(UIColor(hexString: "#323232")))
                        .font(.system(size: 15, weight: .bold))
                    Spacer()
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 15)
                Spacer()
                
                ZStack{
                    if urlweb.isEmpty {
                        CardLoadingWebview()
                    }else{
                        if title == "Dashboard Radar" {
                            WebView(url: URL(string: urlweb)!, showLoading: $showLoading)
                                .overlay(showLoading ? ProgressView("Loading...").toAnyView() : EmptyView().toAnyView())
                        }else{
                            WebView(url: URL(string: baseUrl+urlweb)!, showLoading: $showLoading)
                                .overlay(showLoading ? ProgressView("Loading...").toAnyView() : EmptyView().toAnyView())
                        }
                        
                    }
                }
                
            }
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
