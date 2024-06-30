//
//  WimModal.swift
//  JID.COM
//
//  Created by Panda on 18/12/22.
//

import SwiftUI

struct WimModal: View {
    var writer : Data_wim
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                VStack{
                    Text("WIM Bridge")
                        .fontWeight(.bold).padding(.top, 7)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.bottom, 15)
                        .foregroundColor(.black)
            
                }
                VStack{
              
                    HStack
                    {
                        Text(writer.nama_lokasi)
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                    }.padding(.top, 3)
                    
                    HStack{
                        Spacer()
                        Text(writer.status == 0 ? "OFF" : "ON")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                            .padding(10)
                        Spacer()
                    }
                    .background(Color(UIColor(hexString: "#DFEFFF")))
                    .cornerRadius(5)
                    .padding(.top, 5)
                    
                    HStack
                    {
                        Text("Respon Induk PJR")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.Respon_Induk_PJR)
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    
                    
                    
                    HStack
                    {
                        Text("Back Office ETLE")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.Back_Office_ETLE)
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    
                    HStack
                    {
                        Text("Last Update")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.waktu_update)
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .background(Color.white)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}

struct WimModal_Previews: PreviewProvider {
    static let sendData = Data_wim(nama_lokasi: "", Respon_Induk_PJR: "", Back_Office_ETLE: "", waktu_update: "", status: 0)
    static var previews: some View {
        WimModal(writer: sendData)
    }
}
