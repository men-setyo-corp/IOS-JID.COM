//
//  WebviewPresent.swift
//  JID.COM
//
//  Created by Macbook on 22/09/22.
//

import SwiftUI
import WebKit
 
struct WebView: UIViewRepresentable {
 
    let url: URL
    let webView = WKWebView()
    @Binding var showLoading: Bool
    var modelLogin : LoginModel = LoginModel()
    
    func makeUIView(context: Context) -> some UIView {
        webView.navigationDelegate = context.coordinator
        webView.evaluateJavaScript("localStorage.setItem(\"token\", \"\(modelLogin.auth)\")")
        let request = URLRequest(url: url)
        webView.backgroundColor = .white
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> WebViewCoordinatoor {
        WebViewCoordinatoor(didStart: {
            webView.evaluateJavaScript("localStorage.setItem(\"token\", \"\(modelLogin.auth)\")")
            showLoading = true
        }, didFinish: {
            showLoading = false
        })
    }
  
}

class WebViewCoordinatoor: NSObject, WKNavigationDelegate{
    var didStart: () -> Void
    var didFinish: () -> Void
    var modelLogin : LoginModel = LoginModel()
    
    init(didStart: @escaping () -> Void = {}, didFinish: @escaping () -> Void = {}) {
        self.didStart = didStart
        self.didFinish = didFinish
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webView.evaluateJavaScript("localStorage.setItem(\"token\", \"\(modelLogin.auth)\")")
        self.didStart()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let css1 = ".grid-rows-* { grid-template-rows: 0px }"
        let js1 = "var style = document.createElement('style'); style.innerHTML = '\(css1)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js1)
        
        let css = "#mobile-expand-button { display: none }"
        let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js)
        
        let css2 = ".flex-grow, flex.z-[10500] { display: none }"
        let js2 = "var style = document.createElement('style'); style.innerHTML = '\(css2)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(js2)
        
        let script = "localStorage.getItem(\"token\")"
        webView.evaluateJavaScript(script){ (value, error) in
            if value != nil {
                print("not nil")
            }else{
                print("is nil")
            }
        }
        self.didFinish()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error)
    }
    
}
