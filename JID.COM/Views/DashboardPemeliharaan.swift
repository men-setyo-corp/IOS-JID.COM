//
//  DashboardPemeliharaan.swift
//  JID.COM
//
//  Created by Panda on 20/09/23.
//

import SwiftUI

struct DashboardPemeliharaan: View {
    
    var body: some View {
        ZStack{
            ScrollView{
                ViewGrafikPemeliharaan()
                ViewGrafikKegiatan()
                ViewGrafikPerJalur()
            }
            .padding(.horizontal)
            .background(.white)
        }
        .padding(.bottom, 45)
    }
}

struct DashboardPemeliharaan_Previews: PreviewProvider {
    static var previews: some View {
        DashboardPemeliharaan()
    }
}
