//
//  HomePage.swift
//  JID.COM
//
//  Created by Macbook on 10/08/22.
//

import SwiftUI
import UIKit
import BottomSheet
import Alamofire
import PopupView

struct MapPage: View {    @State var offset: CGFloat = 0
    @State var translation: CGSize = CGSize(width: 0, height: 0)
    
    @State private var showingCredits = false
    @State private var showAlertLogout = false
    @State var isActive = false
    @State private var showingSheet = false
    @State private var showPopup = false
    @State private var showingCctv = true
    
    @State var showCarousel : Bool
    @State var idruas : Int
    @State var stopRun : Bool
    
    @StateObject var modelLogin : LoginModel = LoginModel()
    
    var body: some View {
        ZStack{
            MapBoxMapView().edgesIgnoringSafeArea(.all)
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)){
                HStack{
                    Button{
                        showingSheet = true
                    } label: {
                        Text(Image("filter_icon"))
                            .font(.system(size:35))
                            .frame(width: 40, height: 40, alignment: .center)
                            .foregroundColor(Color.white)
                            .padding(5)
                    }
                    .background(Color(UIColor(hexString: "#DFEFFF")))
                    .cornerRadius(30.5)
                    .padding()
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3,y: 3)
                    
                    Spacer()
                }
                Layerset(isShowModal: $showingSheet)
                
            }
            
            ZStack{
                CctvCarousel(isShowCctv: $showCarousel, idruas: $idruas, stopRun: $stopRun)
            }
            .padding(.bottom, 45)
        }
        
    }
}

struct MapPage_Previews: PreviewProvider {
    static var previews: some View {
        MapPage(showCarousel: false, idruas: 0, stopRun: true)
    }
}
