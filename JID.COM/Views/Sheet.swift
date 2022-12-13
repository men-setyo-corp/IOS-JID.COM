//
//  Sheet.swift
//  JID.COM
//
//  Created by Macbook on 25/08/22.
//

import SwiftUI

struct Sheet: View {
    
    @State private var isActionSheet = false
    @State var showingSheet = false
    
    var body: some View {
        Button(action: {
            self.isActionSheet = true
        }) {
            Text("ActionSheet")
            .foregroundColor(Color.white)
        }
        .padding()
        .background(Color.blue)
        .actionSheet(isPresented: $isActionSheet, content: {
            ActionSheet(title: Text("iOSDevCenters"), message: Text("SubTitle"), buttons: [
                .default(Text("Save"), action: {
                    print("Save")
                }),
                .default(Text("Delete"), action: {
                    print("Delete")
                }),
                .destructive(Text("Cancel"))
                ])
        })
    }
}

struct Sheet_Previews: PreviewProvider {
    static var previews: some View {
        Sheet()
    }
}
