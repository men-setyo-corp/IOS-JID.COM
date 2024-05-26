//
//  SplashScrean.swift
//  JID.COM
//
//  Created by Panda on 07/11/22.
//

import SwiftUI

struct SplashScrean: View {
    @State private var isActive = false
    @State private var opacity = 0.5
    var body: some View {
        if isActive == true {
            ContentView()
        }else{
            VStack{
                VStack{
                    Image("logonew")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                }
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.2)){
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                    withAnimation{
                        self.isActive = true
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(.white)
           
        }
        
    }
}

struct SplashScrean_Previews: PreviewProvider {
    static var previews: some View {
        SplashScrean()
    }
}
