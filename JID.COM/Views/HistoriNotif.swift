//
//  HistoriNotif.swift
//  JID.COM
//
//  Created by Panda on 21/12/22.
//

import SwiftUI

struct HistoriNotif: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button{
                        self.presentationMode.wrappedValue.dismiss()
                    }label:{
                        Text(Image(systemName: "chevron.backward"))
                            .foregroundColor(Color(UIColor(hexString: "#323232")))
                            .font(.system(size: 20, weight: .bold))
                    }
                    Spacer()
                    Text("Hitori Notifikasi")
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                .padding(.horizontal,25)
                Spacer()
                Text("Welcome Histori notifikasi")
                    .foregroundColor(Color.black)
                Spacer()
            }
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            print("hotoiri notif")
            HistoriNotifModel().loadHistori{ (dataresult) in
                print(dataresult)
            }
        }
    }
}

struct HistoriNotif_Previews: PreviewProvider {
    static var previews: some View {
        HistoriNotif()
    }
}
