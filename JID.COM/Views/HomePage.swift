//
//  HomePage.swift
//  JID.COM
//
//  Created by Macbook on 15/09/22.
//

import SwiftUI

struct HomePage: View {
    
    @State var btnGangguan : Bool = true
    @State var btnRekayasa : Bool = false
    @State var btnPemeliha : Bool = false
    
    @State var dataresult : [Kejadian] = []
    @State var tipe_lalin : String = ""
    @State var isShowModal : Bool = false
    
    @State var dataInSide = Data_event_lalin(id: 0 , title: "", nama_ruas: "", km: "", jalur: "", lajur: "", waktu: "", jenis_event: "", arah_jalur: "", ket_status: "", ket: "", range_km: "", waktu_end: "")
    
    var body: some View {
        ZStack{
            ScrollView{
                VStack{
                    ZStack{
                        VStack{
                            HStack{
                                HStack{
                                    Button{
                                        Task{
                                            do{
                                                dataresult = []
                                                btnGangguan = true
                                                btnRekayasa = false
                                                btnPemeliha = false
                                                tipe_lalin = "gangguan"
                                                KejadianLalin().getKejadianLalin(tipe_lalin: tipe_lalin){ result in
                                                    self.dataresult = result
                                                }
                                            }
                                        }
                                    }label:{
                                        Spacer()
                                        VStack{
                                            Image(systemName: "car.fill")
                                                .font(.system(size: 30, weight: .bold))
                                                .foregroundColor(btnGangguan ? Color(UIColor(hexString: "#390099")) : Color(UIColor(hexString: "#DFEFFF")))
                                            Text("Gangguan\nLalin")
                                                .padding(.top, 1)
                                                .font(.system(size: 13))
                                                .foregroundColor(btnGangguan ? Color(UIColor(hexString: "#390099")) : Color(UIColor(hexString: "#DFEFFF")))
                                        }
                                        .padding(.vertical, 5)
                                        Spacer()
                                    }
                                    .background(btnGangguan ? Color(UIColor(hexString: "#DFEFFF")) : Color(UIColor(hexString: "#390099")))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 1)
                                    
                                    Button{
                                        Task{
                                            do{
                                                dataresult = []
                                                btnGangguan = false
                                                btnRekayasa = true
                                                btnPemeliha = false
                                                tipe_lalin = "rekayasa"
                                                KejadianLalin().getKejadianLalin(tipe_lalin: tipe_lalin){ result in
                                                    self.dataresult = result
                                                }
                                            }
                                        }
                                    }label:{
                                        Spacer()
                                        VStack{
                                            Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                                                .font(.system(size: 30, weight: .bold))
                                                .foregroundColor(btnRekayasa ? Color(UIColor(hexString: "#390099")) : Color(UIColor(hexString: "#DFEFFF")))
                                            Text("Rekayasa\nLalin")
                                                .padding(.top, 0)
                                                .font(.system(size: 13))
                                                .foregroundColor(btnRekayasa ? Color(UIColor(hexString: "#390099")) : Color(UIColor(hexString: "#DFEFFF")))
                                        }
                                        .padding(.vertical, 5)
                                        Spacer()
                                    }
                                    .background(btnRekayasa ? Color(UIColor(hexString: "#DFEFFF")) : Color(UIColor(hexString: "#390099")))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 1)
                                    
                                    Button{
                                        Task{
                                            do{
                                                dataresult = []
                                                btnGangguan = false
                                                btnRekayasa = false
                                                btnPemeliha = true
                                                tipe_lalin = "pemeliharaan"
                                                KejadianLalin().getKejadianLalin(tipe_lalin: tipe_lalin){ result in
                                                    self.dataresult = result
                                                }
                                            }
                                        }
                                    }label:{
                                        Spacer()
                                        VStack{
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .font(.system(size: 30, weight: .bold))
                                                .foregroundColor(btnPemeliha ? Color(UIColor(hexString: "#390099")) : Color(UIColor(hexString: "#DFEFFF")))
                                            Text("Pemeliharaan\nJalan Tol")
                                                .padding(.top, 1)
                                                .font(.system(size: 13))
                                                .foregroundColor(btnPemeliha ? Color(UIColor(hexString: "#390099")) : Color(UIColor(hexString: "#DFEFFF")))
                                        }
                                        .padding(.vertical, 5)
                                        Spacer()
                                    }
                                    .background(btnPemeliha ? Color(UIColor(hexString: "#DFEFFF")) : Color(UIColor(hexString: "#390099")))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 1)
                                    
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                            }
                            .background(Color(UIColor(hexString: "#390099")))
                            
                            VStack{
                                HStack{
                                    Spacer()
                                    Text("Waktu")
                                        .font(.system(size: 12, weight: .bold))
                                        .frame(width: 80, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    Text("KM")
                                        .font(.system(size: 12, weight: .bold))
                                        .frame(width: 50, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    Text("Jenis")
                                        .font(.system(size: 12, weight: .bold))
                                        .frame(width: 80, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 5)
                                .background(Color(UIColor(hexString: "#DFEFFF")))
                                
                                ScrollView{
                                    if self.dataresult.isEmpty {
                                        ForEach(0...3,id: \.self){_ in
                                            CardKejadian()
                                        }
                                    }else{
                                        ForEach(dataresult) { result in
                                            Button{
                                                isShowModal =  true
                                                var titleJdl = ""
                                                if btnGangguan == true {
                                                    titleJdl = "Gangguan Lalu Lintas"
                                                }else if btnPemeliha == true {
                                                    titleJdl = "Pemeliharaan Lalu Lintas"
                                                }else if btnRekayasa == true {
                                                    titleJdl = "Rekayasa Lalu Lintas"
                                                }
                                                dataInSide = Data_event_lalin(id: result.idx , title: titleJdl, nama_ruas: result.nama_ruas, km: result.km, jalur: result.jalur, lajur: result.lajur, waktu: result.waktu, jenis_event: result.jenis_event, arah_jalur: result.arah_jalur, ket_status: result.ket_status, ket: result.ket, range_km: result.range_km, waktu_end: result.waktu_end)
                                                
                                            }label:{
                                                VStack{
                                                    HStack{
                                                        Spacer()
                                                        Text(result.waktu)
                                                            .font(.system(size: 12))
                                                            .frame(width: 80, alignment: .center)
                                                            .multilineTextAlignment(.center)
                                                            .foregroundColor(result.ket_status == "Dalam Penanganan" || result.ket_status == "Dalam Proses" ? .orange : .red)
                                                        
                                                        Spacer()
                                                        Text(result.km)
                                                            .font(.system(size: 12))
                                                            .frame(width: 50, alignment: .center)
                                                            .multilineTextAlignment(.center)
                                                            .foregroundColor(result.ket_status == "Dalam Penanganan" || result.ket_status == "Dalam Proses" ? .orange : .red)
                                                        
                                                        Spacer()
                                                        Text(result.jenis_event)
                                                            .font(.system(size: 12))
                                                            .frame(width: 80, alignment: .center)
                                                            .multilineTextAlignment(.center)
                                                            .foregroundColor(result.ket_status == "Dalam Penanganan" || result.ket_status == "Dalam Proses" ? .orange : .red)
                                                        
                                                        Spacer()
                                                    }
                                                    Divider()
                                                     .frame(height: 1)
                                                     .padding(.horizontal, 10)
                                                     .background(Color(UIColor(hexString: "#DFEFFF")))
                                                }
                                                .frame(alignment: .center)
                                            }
                                            
                                            
                                        }
                                    }
                                }
                                
                                
                                HStack{
                                    Rectangle()
                                        .fill(.red)
                                        .frame(width: 10, height: 10)
                                        .cornerRadius(50)
                                    Text("Belum Di Tangani")
                                        .font(.system(size: 9))
                                        .foregroundColor(.black)
                                    
                                    Rectangle()
                                        .fill(.orange)
                                        .frame(width: 10, height: 10)
                                        .cornerRadius(50)
                                    Text("Dalam Proses")
                                        .font(.system(size: 9))
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 300, alignment: .topLeading)
                    .background(Color(.white))
                    .cornerRadius(15)
                    .padding(.top, 10)
                    .shadow(radius: 2)
                    
                    MenuDashboard()
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            DetailEventLalin(isShowModal: $isShowModal, dataDetailEvent: dataInSide)
            
        }
        .onAppear{
            tipe_lalin = "gangguan"
            KejadianLalin().getKejadianLalin(tipe_lalin: "gangguan"){ result in
                self.dataresult = result
            }
        }
        .background(.white)
    }
}


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

struct CardKejadian: View {
    @State var show = false
    var center = (UIScreen.main.bounds.width / 2) + 110
    
    var body: some View{
        ZStack{
            Color.black.opacity(0.09)
            .cornerRadius(0)
            
            Color.white
            .cornerRadius(0)
            .mask(
                Rectangle()
                .fill(
                    LinearGradient(gradient: .init(colors: [.clear, Color.white.opacity(0.18)]), startPoint: .top, endPoint: .bottom)
                )
                .rotationEffect(.init(degrees: 75))
                .offset(x: self.show ? center: -center)
            )
        }
        .frame(height: 25)
    }
}
