//
//  HomePage.swift
//  JID.COM
//
//  Created by Macbook on 10/08/22.
//

import SwiftUI
import BottomSheet

struct HomePage: View {
    
    @State private var bottomSheetPosition: BottomSheetPosition = .middle
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack{
            MapBoxMapView().edgesIgnoringSafeArea(.all)
        }
        
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
