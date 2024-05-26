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
    @State var showloadinglist : Bool = true
    @State var tipe_lalin : String = ""
    @State var isShowModal : Bool = false
    
    @State var dataInSide = Data_event_lalin(id: 0 , title: "", nama_ruas: "", nama_ruas_2: "", km: "", jalur: "", lajur: "", waktu: "", jenis_event: "", arah_jalur: "", ket_status: "", ket: "", range_km: "", waktu_end: "")
    
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
                                                showloadinglist = true
                                                dataresult = []
                                                btnGangguan = true
                                                btnRekayasa = false
                                                btnPemeliha = false
                                                tipe_lalin = "gangguan"
                                                KejadianLalin().getKejadianLalin(tipe_lalin: tipe_lalin){ result in
                                                    self.dataresult = result
                                                    
                                                    if self.dataresult.isEmpty{
                                                        self.showloadinglist = false
                                                    }else{
                                                        self.showloadinglist = true
                                                    }
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
                                                showloadinglist = true
                                                dataresult = []
                                                btnGangguan = false
                                                btnRekayasa = true
                                                btnPemeliha = false
                                                tipe_lalin = "rekayasa"
                                                KejadianLalin().getKejadianLalin(tipe_lalin: tipe_lalin){ result in
                                                    self.dataresult = result
                                                    if self.dataresult.isEmpty{
                                                        self.showloadinglist = false
                                                    }else{
                                                        self.showloadinglist = true
                                                    }
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
                                                showloadinglist = true
                                                dataresult = []
                                                btnGangguan = false
                                                btnRekayasa = false
                                                btnPemeliha = true
                                                tipe_lalin = "pemeliharaan"
                                                KejadianLalin().getKejadianLalin(tipe_lalin: tipe_lalin){ result in
                                                    self.dataresult = result
                                                    if self.dataresult.isEmpty{
                                                        self.showloadinglist = false
                                                    }else{
                                                        self.showloadinglist = true
                                                    }
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
                                        .font(.system(size: 11, weight: .bold))
                                        .frame(width: 60, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    Text("Ruas/KM")
                                        .font(.system(size: 11, weight: .bold))
                                        .frame(width: 80, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    Text("Jenis")
                                        .font(.system(size: 11, weight: .bold))
                                        .frame(width: 70, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    Text("")
                                        .font(.system(size: 11, weight: .bold))
                                        .frame(width: 10, alignment: .center)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 5)
                                .background(Color(UIColor(hexString: "#DFEFFF")))
                                
                                GeometryReader { geometry in
                                    ScrollView{
                                        if self.dataresult.isEmpty {
                                            if showloadinglist == true {
                                                ForEach(0...5,id: \.self){_ in
                                                    CardKejadian()
                                                }
                                            }else{
                                                if tipe_lalin == "gangguan" {
                                                    Text("Saat ini Belum ada Gangguan Lalin !")
                                                        .font(.system(size: 11, weight: .bold))
                                                        .frame(width: geometry.size.width)
                                                        .frame(minHeight: geometry.size.height)
                                                        .foregroundColor(.black)
                                                }else if tipe_lalin == "rekayasa" {
                                                    Text("Saat ini Belum ada Rekayasa Lalin !")
                                                        .font(.system(size: 11, weight: .bold))
                                                        .frame(width: geometry.size.width)
                                                        .frame(minHeight: geometry.size.height)
                                                        .foregroundColor(.black)
                                                }else if tipe_lalin == "pemeliharaan"{
                                                    Text("Saat ini Belum ada Pemeliharaan Lalin !")
                                                        .font(.system(size: 11, weight: .bold))
                                                        .frame(width: geometry.size.width)
                                                        .frame(minHeight: geometry.size.height)
                                                        .foregroundColor(.black)
                                                }
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
                                                    
                                                    dataInSide = Data_event_lalin(id: result.id , title: titleJdl, nama_ruas: result.nama_ruas, nama_ruas_2: result.nama_ruas_2, km: result.km, jalur: result.jalur, lajur: result.lajur, waktu: result.waktu, jenis_event: result.jenis_event, arah_jalur: result.arah_jalur, ket_status: result.ket_status, ket: result.ket, range_km: result.range_km, waktu_end: result.waktu_end ?? "-")
                                                    
                                                }label:{
                                                    VStack{
                                                        HStack{
                                                            Spacer()
                                                            Text(result.waktu)
                                                                .font(.system(size: 10))
                                                                .frame(width: 60, alignment: .center)
                                                                .multilineTextAlignment(.center)
                                                                .foregroundColor(.black)
                                                            
                                                            Spacer()
                                                            Text("\(result.nama_ruas_2)/\(result.km) \(result.jalur)")
                                                                .font(.system(size: 10))
                                                                .frame(width: 80, alignment: .center)
                                                                .multilineTextAlignment(.center)
                                                                .foregroundColor(.black)
                                                            
                                                            Spacer()
                                                            Text(result.jenis_event)
                                                                .font(.system(size: 10))
                                                                .frame(width: 70, alignment: .center)
                                                                .multilineTextAlignment(.center)
                                                                .foregroundColor(.black)
                                                            
                                                            Spacer()
                                                            Rectangle()
                                                                .fill(result.ket_status == "Dalam Penanganan" || result.ket_status == "Dalam Proses" ? .orange : .red)
                                                                .frame(width: 15, height: 15)
                                                                .cornerRadius(50)
                                                            
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
                                }
                                
                                
                                HStack{
                                    Rectangle()
                                        .fill(.red)
                                        .frame(width: 10, height: 10)
                                        .cornerRadius(50)
                                    Text(btnGangguan == true ? "Belum Ditangani" : "Dalam Rencana")
                                        .font(.system(size: 9))
                                        .foregroundColor(.black)
                                    
                                    Rectangle()
                                        .fill(.orange)
                                        .frame(width: 10, height: 10)
                                        .cornerRadius(50)
                                    Text(btnGangguan == true ? "Dalam Penanganan" : "Dalam Proses")
                                        .font(.system(size: 9))
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 350, alignment: .topLeading)
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
                if self.dataresult.isEmpty{
                    self.showloadinglist = false
                }else{
                    self.showloadinglist = true
                }
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
