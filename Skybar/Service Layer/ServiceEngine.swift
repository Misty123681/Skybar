//
//  ServiceInterface.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/29/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import Reachability
import Foundation

public typealias APICompletionHandler = (_ success:Bool,_ result:AnyObject?) -> Void
enum MethodName:String{
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
}
class ServiceEngine: NSObject {
    
    
    var cancelleableTask:URLSessionDataTask!
    
    private func clearCookies(forURL URL: URL) -> Void {
        let cookieStorage = HTTPCookieStorage.shared
        let cookies = cookieStorage.cookies(for: URL) ?? []
        for cookie in cookies {
            print("Deleting cookie for domain: \(cookie.domain)")
            cookieStorage.deleteCookie(cookie)
        }
    }
    
    public class var sharedInstance: ServiceEngine {
        
        struct Static {
            static let instance = ServiceEngine()
        }
        return Static.instance
    }
    
    public func startTask(pathURL:String,httpMethod:MethodName,addMobileSession:Bool=true,uriparams:[String:Any]?,bodyparams:[String:Any]?=nil,completionHandler:@escaping APICompletionHandler){
        
        if !(NetworkConnection.isConnectedToNetwork()){
            SkybarAlert().showAlert(NSLocalizedString("Check Network", comment: ""))
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NetworkIssue"), object: nil)
            return
        }
        
        var paramStr = "?"
        
        if addMobileSession{
            if let mobileSessionID = ServiceUser.getMobileSessionID(){
                paramStr += "MobileSessionID=\(mobileSessionID)&"
            }
        }
        
        if let params = uriparams{
            for key in params.keys{
                if let value = params[key]{
                    paramStr += "\(key)=\(value)&"
                }
            }
        }
        
        paramStr.removeLast()
        var fullURL = "\(pathURL)\(paramStr)"
        fullURL = fullURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: fullURL)
        print(url!)
        var request:URLRequest = URLRequest(url: url!)
        request.httpMethod = httpMethod.rawValue
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
         request.timeoutInterval = 60
        
        if let params = bodyparams{
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                let requestBody = String(data: request.httpBody!, encoding: String.Encoding.utf8)
                print(requestBody!)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        clearCookies(forURL: url!)
        URLCache.shared.removeAllCachedResponses()
        print("response url: "+fullURL)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            URLCache.shared.removeAllCachedResponses()
            //URLSession.shared.finishTasksAndInvalidate()
            
            if let httpResponse = response as? HTTPURLResponse {
                if let headerStatus = httpResponse.allHeaderFields["Status"] as? String{
                    print("response header status: \(headerStatus)")
                }
                print("response code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode != 200 {
                    if let data = data {
                        print("response url: "+fullURL)
                        let backToString = String(data: data, encoding: String.Encoding.utf8)
                        print(backToString ?? String())
                        ServiceInterface.logError(error: backToString ?? "", handler: nil)
                    }else{
                        ServiceInterface.logError(error: "Internal Error", handler: nil)
                    }
                    
                    DispatchQueue.main.async {
                        completionHandler(false, "Internal Error" as AnyObject)
                    }
                    return
                }
                
            }
            
            guard error == nil else {
                print(error!)
                ServiceInterface.logError(error: error?.localizedDescription ?? "", handler: nil)
                completionHandler(false, error?.localizedDescription as AnyObject)
                return
            }
            
            guard let data = data else {
                print("Data is empty")
                ServiceInterface.logError(error: "No Data", handler: nil)
                completionHandler(false, "No Data" as AnyObject)
                return
            }
            
            DispatchQueue.main.async {
                let backToString = String(data: data, encoding: String.Encoding.utf8)
                print(backToString ?? String())
                completionHandler(true, data as AnyObject)
            }
        }
        
        task.resume()
    }
    
    public func startTaskCancelleable(pathURL:String,httpMethod:MethodName,addMobileSession:Bool=true,uriparams:[String:Any]?,bodyparams:[String:Any]?=nil,completionHandler:@escaping APICompletionHandler){
        
        if !(NetworkConnection.isConnectedToNetwork()){
            SkybarAlert().showAlert(NSLocalizedString("Check Network", comment: ""))
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NetworkIssue"), object: nil)
            return
        }
        var paramStr = "?"
        
        if addMobileSession{
            if let mobileSessionID = ServiceUser.getMobileSessionID(){
                paramStr += "MobileSessionID=\(mobileSessionID)&"
            }
        }
        
        if let params = uriparams{
            for key in params.keys{
                if let value = params[key]{
                    paramStr += "\(key)=\(value)&"
                }
            }
        }
        
        paramStr.removeLast()
        var fullURL = "\(pathURL)\(paramStr)"
        fullURL = fullURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = URL(string: fullURL)
        var request:URLRequest = URLRequest(url: url!)
        request.httpMethod = httpMethod.rawValue
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 30
        
        if let params = bodyparams{
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
                let requestBody = String(data: request.httpBody!, encoding: String.Encoding.utf8)
                print(requestBody!)
                
            } catch let error {
                print(error.localizedDescription)
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        clearCookies(forURL: url!)
        URLCache.shared.removeAllCachedResponses()
        print("response url: "+fullURL)
        
        if let _ = self.cancelleableTask{
            self.cancelleableTask.cancel()
        }
        
        self.cancelleableTask = URLSession.shared.dataTask(with: request) { data, response, error in
            URLCache.shared.removeAllCachedResponses()
            //URLSession.shared.finishTasksAndInvalidate()
            
            if let httpResponse = response as? HTTPURLResponse {
                if let headerStatus = httpResponse.allHeaderFields["Status"] as? String{
                    print("response header status: \(headerStatus)")
                }
                print("response code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode != 200 {
                    if let data = data {
                        let backToString = String(data: data, encoding: String.Encoding.utf8)
                        print(backToString ?? String())
                        ServiceInterface.logError(error: backToString ?? "", handler: nil)
                    }else{
                        ServiceInterface.logError(error: "Internal Error", handler: nil)
                    }
                    
                    DispatchQueue.main.async {
                        completionHandler(false, "Internal Error" as AnyObject)
                    }
                    return
                }
                
            }
            
            guard error == nil else {
                print(error!)
                ServiceInterface.logError(error: error?.localizedDescription ?? "", handler: nil)
                completionHandler(false, error?.localizedDescription as AnyObject)
                return
            }
            
            guard let data = data else {
                print("Data is empty")
                ServiceInterface.logError(error: "No Data", handler: nil)
                completionHandler(false, "No Data" as AnyObject)
                return
            }
            
            DispatchQueue.main.async {
                let backToString = String(data: data, encoding: String.Encoding.utf8)
                print(backToString ?? String())
                completionHandler(true, data as AnyObject)
            }
        }
        
        self.cancelleableTask.resume()
    }
}

