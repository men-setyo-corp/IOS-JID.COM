//
//  RestApi.swift
//  JID.COM
//
//  Created by Macbook on 10/08/22.
//

import UIKit

class RestApi: NSObject {
    func getAPI(from url: URL, completion: @escaping (_ data: JSONObject?) -> ()) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2345391662", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: (request), completionHandler: { getdata, response, error in
            guard let getdata = getdata, error == nil else{
                print("something went wrong of get data")
                return
            }
            var result: responseAPI?
            do{
                result = try JSONDecoder().decode(responseAPI.self, from: getdata)
            }catch{
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let json = result else{
                return
            }
            DispatchQueue.main.async {
                completion(json.data)
            }
            
        })
        task.resume()
    }
    
}
