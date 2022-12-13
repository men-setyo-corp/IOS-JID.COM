//
//  RemoteImageUrl.swift
//  JID.COM
//
//  Created by Macbook on 28/09/22.
//
import Foundation
import UIKit

class RemoteImageUrl: BindableObject{
    let didChange = PassthroughSubject<Data, Never>()
    
    var data = Data(){
        didSet{
            didChange.send(data)
        }
    }
    
    init(imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}
