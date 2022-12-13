//
//  ConManager.swift
//  JID.COM
//
//  Created by Macbook on 12/08/22.
//

import Network

class ConManager{
    
    let monitor = NWPathMonitor()
    
    func checkIntr() -> Bool {
        var status = false
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        _ = NWPathMonitor(requiredInterfaceType: .cellular)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                DispatchQueue.main.async {
                    status = true
                }
                
            } else {
                print("No connection.")
                DispatchQueue.main.async {
                    status = false
                }
            }
        }
        return status
    }
}
