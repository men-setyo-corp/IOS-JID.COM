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
    
    @State var showWarning : Bool = false
    
    @State var itemsList : [String] = []
    @State var scopeList : [String] = []
    @State var reportList : [String] = []
    @State var dashboardList : [String] = []
    
    
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
                                if val == 4 || val == 6 {
                                    let keyCek = ["", "","","","rams","","rough"]
                                    let HcekData = cekItmes(key: keyCek[val], sumber: "items")
                                    if HcekData != "sama" {
                                        showWarning.toggle()
                                    }else{
                                        if getStsInfo[val]=="yes" {
                                            getStsInfo[val] = "no"
                                        }else{
                                            getStsInfo[val] = "yes"
                                        }
                                        Dataset.stsInfoJalanTol = getStsInfo
                                    }
                                }else{
                                    if getStsInfo[val]=="yes" {
                                        getStsInfo[val] = "no"
                                    }else{
                                        getStsInfo[val] = "yes"
                                    }
                                    Dataset.stsInfoJalanTol = getStsInfo
                                }
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
                            .alert("Maaf anda tidak memiliki akses" ,isPresented: $showWarning){
                                //alert in button
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
                                if val == 0 || val == 1 || val == 2 || val == 3 || val == 4 || val == 5 || val == 6 || val == 7 || val == 8 || val == 9 || val == 10 {
                                    let keyCek = ["vms", "cctv","rtms","rtms2","radar","speed","level","pump","wim","cars","bike"]
                                    let HcekData = cekItmes(key: keyCek[val], sumber: "items")
                                    if HcekData != "sama" {
                                        showWarning.toggle()
                                    }else{
                                        if getStsSisin[val]=="yes" {
                                            getStsSisin[val] = "no"
                                        }else{
                                            getStsSisin[val] = "yes"
                                        }
                                        Dataset.stsSisinfokom = getStsSisin
                                    }
                                }else{
                                    if getStsSisin[val]=="yes" {
                                        getStsSisin[val] = "no"
                                    }else{
                                        getStsSisin[val] = "yes"
                                    }
                                    Dataset.stsSisinfokom = getStsSisin
                                }
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
                            .alert("Maaf anda tidak memiliki akses" ,isPresented: $showWarning){
                                //alert in button
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
    
    func cekItmes(key:String, sumber: String) -> String {
        let itemLayar = modelLogin.item
        itemsList = itemLayar.components(separatedBy: ",")
        let scopeLayar = self.modelLogin.scope
        scopeList = scopeLayar.components(separatedBy: ",")
        let dashboardLayar = self.modelLogin.dashboard
        dashboardList = dashboardLayar.components(separatedBy: ",")
        let reportLayar = self.modelLogin.report
        reportList = reportLayar.components(separatedBy: ",")
        
        var returnlet : String = ""
        if sumber == "dashboard" {
            if dashboardList.contains(key) {
                returnlet = "sama"
            }else{
                returnlet = "beda"
            }
        }
        
        if sumber == "scope" {
            if scopeList.contains(key) {
                returnlet = "sama"
            }else{
                returnlet = "beda"
            }
        }
        
        if sumber == "report" {
            if reportList.contains(key) {
                returnlet = "sama"
            }else{
                returnlet = "beda"
            }
        }
        
        if sumber == "items" {
            if itemsList.contains(key) {
                returnlet = "sama"
            }else{
                returnlet = "beda"
            }
        }
        
        return returnlet
    }
    
}

struct LayerList_Previews: PreviewProvider {
    static var previews: some View {
        LayerList()
    }
}
