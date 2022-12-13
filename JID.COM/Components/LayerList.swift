//
//  LayerList.swift
//  JID.COM
//
//  Created by Macbook on 09/10/22.
//

import SwiftUI

struct LayerList: View {
    
    @StateObject var modelLogin : LoginModel = LoginModel()
    
    var items: [GridItem] {
      Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }
    
    @State var nameIconCheck = "circle"
    @State var presCheck = false
    
    let iconEvent = ["car.fill", "arrow.triangle.turn.up.right.diamond.fill","exclamationmark.triangle.fill"]
    
    @State var getInfo = Dataset().info_jalan_tol
    @State var getSisin = Dataset().sisinfokom
    @State var getEvent = Dataset().event_jalan_tol
    //sttaus layer
    @State var getStsInfo = Dataset.stsInfoJalanTol
    @State var getStsSisin = Dataset.stsSisinfokom
    @State var getStsEvent = Dataset.stsEventTol
//    
//    var itemLayar = self.modelLogin.item
//    var layarList = itemLayar.components(separatedBy: ",")
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                HStack{
                    Text("Filter Informasi")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                    Spacer()
//                    Image(systemName: nameIconCheck)
//                        .foregroundColor(presCheck ? Color(UIColor(hexString: "#2F52BE")) : Color(UIColor(hexString: "#A1A1A1")))
//                        .onTapGesture(perform: {
//                            presCheck.toggle()
//                            if presCheck {
//                                nameIconCheck = "checkmark.circle.fill"
//                            }else{
//                                nameIconCheck = "circle"
//                            }
//                        })
//
//                    Text("Tampilkan Semuanya")
//                        .font(.system(size: 15))
//                        .foregroundColor(presCheck ? Color(UIColor(hexString: "#000000")) : Color(UIColor(hexString: "#A1A1A1")))
                }
                Text("Pilih untuk mendapatkan informasi tertentu")
                    .padding(.vertical, 1)
                    .foregroundColor(Color(UIColor(hexString: "#A1A1A1")))
                    .font(.system(size: 15))
                
                ScrollView{
                    Text("Info Jalan Tol")
                        .font(.system(size: 15))
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundColor(.black)
                    
                    LazyVGrid(columns: items, spacing: 10) {
                        ForEach (0..<getInfo.count){ val in
                            Button{
                                if getStsInfo[val]=="yes" {
                                    getStsInfo[val] = "no"
                                }else{
                                    getStsInfo[val] = "yes"
                                }
                                Dataset.stsInfoJalanTol = getStsInfo
                                print("change kayar")
                            }label:{
                                Text("\(getInfo[val])")
                                    .font(.system(size: 9))
                                    .foregroundColor(getStsInfo[val]=="yes" ? Color.black : Color.gray)
                                    .padding(10)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                    .background(getStsInfo[val]=="yes" ? Color(UIColor(hexString: "#DFEFFF")) : nil)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(getStsInfo[val]=="yes" ? Color(UIColor(hexString: "#390099")) : .gray, lineWidth: 2)
                                    )
                                    .cornerRadius(50)
                            }
                            
                        }
                        
                    }
                    .padding(.top, 10)
                    
                    //LIST DATA SISINFOKOM
                    Text("Sisinfokom")
                        .font(.system(size: 15))
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundColor(.black)
                    LazyVGrid(columns: items, spacing: 10) {
                        ForEach (0..<getSisin.count){ val in
                            Button{
                                if getStsSisin[val]=="yes" {
                                    getStsSisin[val] = "no"
                                }else{
                                    getStsSisin[val] = "yes"
                                }
                                Dataset.stsSisinfokom = getStsSisin
                            }label:{
                                Text("\(getSisin[val])")
                                    .font(.system(size: 9))
                                    .foregroundColor(getStsSisin[val]=="yes" ? Color.black : Color.gray)
                                    .padding(10)
                                    .frame(maxWidth:.infinity, alignment: .leading)
                                    .background(getStsSisin[val]=="yes" ? Color(UIColor(hexString: "#DFEFFF")) : nil)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(getStsSisin[val]=="yes" ? Color(UIColor(hexString: "#390099")) : .gray, lineWidth: 2)
                                    )
                                    .cornerRadius(50)
                            }
                        }
                        
                    }
                    .padding(.top, 10)
                    
                    //LIST DATA Event Jala Tol
                    Text("Event jalan Tol")
                        .font(.system(size: 15))
                        .padding(.top, 20)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundColor(.black)
                    HStack{
                        ForEach (0..<getEvent.count){ val in
                            Spacer()
                            VStack{
                                Button{
                                    if getStsEvent[val]=="yes" {
                                        getStsEvent[val] = "no"
                                    }else{
                                        getStsEvent[val] = "yes"
                                    }
                                    Dataset.stsEventTol = getStsEvent
                                } label:{
                                    Image(systemName: iconEvent[val])
                                        .font(.system(size: 25, weight: .bold))
                                        .foregroundColor(getStsEvent[val]=="yes" ? Color(UIColor(hexString: "#390099")) : Color.black)
                                }
                                .padding(15)
                                .background(getStsEvent[val] == "yes" ? Color(UIColor(hexString: "#DFEFFF")) : nil)
                                .overlay(
                                    Circle()
                                        .stroke(getStsEvent[val]=="yes" ? Color(UIColor(hexString: "#DFEFFF")) : .gray, lineWidth: 2)
                                )
                                .clipShape(Circle())
                                Text("\(getEvent[val])")
                                    .font(.system(size:12))
                                    .foregroundColor(getStsEvent[val] == "yes" ? Color(UIColor(hexString: "#390099")) : Color.gray)
                                    .multilineTextAlignment(.center)
                            }.frame(alignment: .center)
                            Spacer()
                        }
                    }
                    
                }
                
                
                
                Spacer()
            }
            .padding(.horizontal, 25)
        }
        .frame(maxHeight: .infinity)
        .padding(.bottom, 1)
        
    }
}

struct LayerList_Previews: PreviewProvider {
    static var previews: some View {
        LayerList()
    }
}
