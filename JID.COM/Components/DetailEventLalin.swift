//
//  DetailEventLalin.swift
//  JID.COM
//
//  Created by Panda on 10/12/22.
//

import SwiftUI

struct DetailEventLalin: View {
    @Binding var isShowModal : Bool
    var dataDetailEvent : Data_event_lalin
    
    var body: some View {
        ZStack(alignment: .center){
            if isShowModal == true {
                Color.black
                    .opacity(0.4 + (0.8 - 0.4))
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowModal = false
                    }
                VStack{
                    VStack(alignment: .leading, spacing: 0){
                        HStack{
                            Spacer()
                            Text(dataDetailEvent.title)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        HStack{
                            Text("Nama Ruas")
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                            Spacer()
                            Text(dataDetailEvent.nama_ruas)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 15)
                        HStack{
                            Text("KM")
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                            Spacer()
                            Text(dataDetailEvent.km)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 10)
                        
                        if dataDetailEvent.title == "Gangguan Lalu Lintas" {
                            HStack{
                                Text("Waktu Kejadian")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                                Spacer()
                                Text(dataDetailEvent.waktu)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .padding(.top, 10)
                        }else{
                            HStack{
                                Text("Range KM Pekerjaan")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                                Spacer()
                                Text(dataDetailEvent.range_km)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .padding(.top, 10)
                            HStack{
                                Text("Waktu Awal")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                                Spacer()
                                Text(dataDetailEvent.waktu)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .padding(.top, 10)
                            HStack{
                                Text("Waktu Akhir")
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                                Spacer()
                                Text(dataDetailEvent.waktu_end)
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.black)
                            }
                            .padding(.top, 10)
                        }
                        
                        HStack{
                            Text("Jenis Pekerjaan")
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                            Spacer()
                            Text(dataDetailEvent.jenis_event)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 10)
                        HStack{
                            Text("Arah Jalur")
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                            Spacer()
                            Text("\(dataDetailEvent.arah_jalur)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 10)
                        HStack{
                            Text("Status")
                                .font(.system(size: 12))
                                .foregroundColor(.black)
                            Spacer()
                            Text(dataDetailEvent.ket_status)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 10)
                        
                        HStack{
                            Text("Keterangan")
                                .font(.system(size: 11))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        Divider()
                         .frame(height: 1)
                         .padding(.horizontal, 10)
                         .background(Color(UIColor(hexString: "#DFEFFF")))
                        HStack{
                            Text(dataDetailEvent.ket)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.top, 10)
                        
                    }
                    
                    Button{
                        isShowModal.toggle()
                    }label:{
                        Text("TUTUP")
                            .padding(15)
                            .font(.system(size: 12))
                            .foregroundColor(Color(UIColor(hexString: "#FFFFFF")))
                            
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color(UIColor(hexString: "#390099")))
                    .cornerRadius(50)
                }
                .frame(width: 310)
                .padding(15)
                .background(Color(.white))
                .cornerRadius(10)
                .shadow(radius: 2)
//                .transition(.move(edge: .bottom))
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea(.all)
        .animation(Animation.easeOut, value: isShowModal)
        
        
    }
}

struct DetailEventLalin_Previews: PreviewProvider {
    static let senddataDetailEvent = Data_event_lalin(id: 0, title: "", nama_ruas: "", nama_ruas_2: "", km: "", jalur: "", lajur: "", waktu: "", jenis_event: "", arah_jalur: "", ket_status: "", ket: "", range_km: "", waktu_end: "")
    
    static var previews: some View {
        DetailEventLalin(isShowModal: .constant(true), dataDetailEvent: senddataDetailEvent)
    }
}
