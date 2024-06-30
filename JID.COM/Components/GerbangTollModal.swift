//
//  GerbangTollModal.swift
//  JID.COM
//
//  Created by Panda on 15/12/22.
//

import SwiftUI

struct GerbangTollModal: View {
    var writer: Data_gerbang_toll
    
    var body: some View {
        ZStack(alignment: .bottom){
            VStack{
                VStack{
                    Text("Gerbang Tol")
                        .fontWeight(.bold)
                        .font(.system(size: 14))
                        .padding(.bottom, 1)
                        .foregroundColor(.black)
                    Text(writer.status == 0 ? "Status OFF" : "Status ON")
                        .padding(.bottom, 20)
                        .padding(.top, 1)
                        .foregroundColor(.black)
                        .font(.system(size: 13, weight: .bold))
                }
                .padding(.top, 20)
                VStack{
                    HStack
                    {
                        Text("Nama Cabang")
                            .foregroundColor(.black)
                            .font(.system(size: 13, weight: .bold))
                        Spacer()
                        Text(writer.nama_cabang)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }
                    HStack
                    {
                        Text("Nama Gerbang")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.nama_gerbang)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                   
                    HStack
                    {
                        Text("Lalin Perjam")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.lalin_perjam)")
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Shift 1 (06:00-14:00)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.lalin_shift_1)")
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Shift 2 (14:00-22:00)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.lalin_shift_2)")
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Shift 3 (22:00-06:00)")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(writer.lalin_shift_3)")
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    HStack
                    {
                        Text("Last Update")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.black)
                        Spacer()
                        Text(writer.last_update)
                            .foregroundColor(.black)
                            .font(.system(size: 13))
                    }.padding(.top, 3)
                    
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(Color.white)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
    }
}

struct GerbangTollModal_Previews: PreviewProvider {
    static let writerPreview = Data_gerbang_toll(id: 0, title: "", kode_cabang: 0, nama_gerbang: "", nama_cabang: "", lalin_shift_1: 0, lalin_shift_2: 0, lalin_shift_3: 0, lalin_perjam: 0, status: 0, last_update: "")
    
    static var previews: some View {
        GerbangTollModal(writer: writerPreview)
    }
}
