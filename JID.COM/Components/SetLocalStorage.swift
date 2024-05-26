//
//  SetLocalStorage.swift
//  JID.COM
//
//  Created by Panda on 11/05/24.
//

import Foundation
import SwiftUI
import WebKit

struct SetLocalStorage : UIViewRepresentable {

    @State var tokenSet : String
    
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        webView.evaluateJavaScript("localStorage.setItem(\"token\", \"\(tokenSet)\")")
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
