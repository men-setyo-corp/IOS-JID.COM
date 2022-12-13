//
//  CctvCarousel.swift
//  JID.COM
//
//  Created by Panda on 29/11/22.
//

import SwiftUI

struct CctvCarousel: View {
    @Binding var isShowCctv : Bool
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CctvCarousel_Previews: PreviewProvider {
    static var previews: some View {
        CctvCarousel(isShowCctv: .constant(true))
    }
}
