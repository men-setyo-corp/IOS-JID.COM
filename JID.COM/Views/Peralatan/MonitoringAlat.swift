//
//  MonitoringAlat.swift
//  JID.COM
//
//  Created by Panda on 15/11/23.
//

import SwiftUI

struct MonitoringAlat: View {
    var body: some View {
        ZStack {
            VStack{
                Text("Monitoring Alat")
                Button {
                    
                }label:{
                    VStack{
                        Text("Monitoring Alat")
                            
                    }
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                }
            }
        }
    }
}

struct MonitoringAlat_Previews: PreviewProvider {
    static var previews: some View {
        MonitoringAlat()
    }
}
