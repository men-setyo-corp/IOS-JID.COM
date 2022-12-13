//
//  ImageLoad.swift
//  JID.COM
//
//  Created by Macbook on 28/09/22.
//

import SwiftUI

struct ImageLoad: View {
    
    let dataimg : WriteImg
    
    var body: some View {
        AsyncImage(url: URL(string: dataimg.urlimg)) { image in
            image
                .resizable()
        } placeholder: {
            CardShimmerImg()
        }
    }
}

struct ImageLoad_Previews: PreviewProvider {
    static let dataImgSend = WriteImg(key_id: "", nama: "", nama_segment: "", urlimg: "")
    
    static var previews: some View {
        ImageLoad(dataimg: dataImgSend)
    }
}
