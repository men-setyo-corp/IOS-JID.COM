//
//  PompaBanjirModal.swift
//  JID.COM
//
//  Created by Panda on 18/12/22.
//

import SwiftUI

struct PompaBanjirModal: View {
    var writer : Data_pompabanjir
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                VStack{
                    Text("Pompa Banjir")
                        .fontWeight(.bold).padding(.top, 7)
                        .font(.system(size: 14, weight: .bold))
                        .padding(.bottom, 15)
                        .foregroundColor(.black)
            
                }
                VStack{
              
                    HStack
                    {
                        Text("Jenis Pompa")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.jenis_pompa)
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Vaolume")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.vol)")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("No Urut Pompa")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.no_urut_pompa)
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Nama Pompa")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.nama_pompa)
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("KW")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.kw)
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Diameter")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.diameter)
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("KM")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.km)
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Jalur")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.jalur)
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Keterangan")
                            .font(.system(size: 13))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.keterangan)
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

struct PompaBanjirModal_Previews: PreviewProvider {
    static let sendData = Data_pompabanjir(jenis_pompa: "", no_urut_pompa: "", vol: 0, nama_pompa: "", kw: "", diameter: "", km: "", jalur: "", keterangan: "")
    
    static var previews: some View {
        PompaBanjirModal(writer: sendData)
    }
}
