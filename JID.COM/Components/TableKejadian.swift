//
//  TableKejadian.swift
//  JID.COM
//
//  Created by Macbook on 21/09/22.
//

import SwiftUI

struct TableKejadian: View {
    
    @State var btnGangguan : Bool = true
    @State var btnRekayasa : Bool = false
    @State var btnPemeliha : Bool = false
    
    @State var dataresult : [Kejadian] = []
    @State var tipe_lalin : String = ""
    
    var body: some View {
        HStack{
            HStack{
                Button{
                    Task{
                        do{
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
                Text("Ruas")
                    .font(.system(size: 13, weight: .bold))
                    .frame(width: 80, alignment: .center)
                
                Spacer()
                Text("KM")
                    .font(.system(size: 13, weight: .bold))
                    .frame(width: 50, alignment: .center)
                
                Spacer()
                Text("Arah")
                    .font(.system(size: 13, weight: .bold))
                    .frame(width: 60, alignment: .center)
                
                Spacer()
                Text("Dampak")
                    .font(.system(size: 13, weight: .bold))
                    .frame(width: 80, alignment: .center)
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
                        VStack{
                            HStack{
                                Spacer()
                                Text(result.nama_ruas)
                                    .font(.system(size: 13))
                                    .frame(width: 80, alignment: .center)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                                Text(result.km)
                                    .font(.system(size: 13))
                                    .frame(width: 50, alignment: .center)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                                Text(result.arah_jalur)
                                    .font(.system(size: 13))
                                    .frame(width: 60, alignment: .center)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                                Text(tipe_lalin == "gangguan" ? result.dampak : "-")
                                    .font(.system(size: 13))
                                    .frame(width: 80, alignment: .center)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                        }
                        .frame(alignment: .center)
                    }
                }
            }
            
            
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
        .background(Color(.white))
    }
}

struct TableKejadian_Previews: PreviewProvider {
    static var previews: some View {
        TableKejadian()
    }
}
