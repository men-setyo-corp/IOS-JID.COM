//
//  TopBarMenu.swift
//  JID.COM
//
//  Created by Macbook on 14/09/22.
//

import SwiftUI

struct TopBarMenu: View {

    var body: some View {
        VStack{
            ZStack{
                HStack{
                    Text("13")
                      .padding()
                      .background(Color(.gray))
                      .clipShape(Circle())
                    
                    VStack(alignment: .leading){
                        Text("Hao")
                        Text("admin6")
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Hao")
                        Text("admin6")
                    }
                }
            }
            .padding(.horizontal)
            Spacer()
        }
    }
}

struct TopBarMenu_Previews: PreviewProvider {
    static var previews: some View {
        TopBarMenu()
    }
}
