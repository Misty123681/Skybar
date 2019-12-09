//
//  SkybarAlert.swift
//  Skybar
//
//  Created by Neosoft on 19/11/19.
//  Copyright © 2019 CSP SOLUTIONS. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration


class SkybarAlert: NSObject {
    
    func showAlert(_ text:String){
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        DispatchQueue.main.async {
            let alertView = UIAlertController(title:"Skybar", message: text, preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
        }
   }
}


/// checking the network reachability functionality
public class NetworkConnection {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
        
    }
}
