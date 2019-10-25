//
//  ServiceUser.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/29/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import MapKit

class ServiceUser: NSObject {
    static var mobileKey = "mobileSessionID"
    static var profile:ProfileObject? = nil
    static var contactPhoneNumber = ""
    static var location:CLLocationCoordinate2D! = nil
    
    static func loggedIn()->Bool{
        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.string(forKey: "LoggedIn"){
            return true
        }
        return false;
    }
    
    static func setProfile(profile:ProfileObject){
        let userDefaults = UserDefaults.standard
        userDefaults.set(profile.firstName, forKey: "firstName")
        userDefaults.set(profile.lastName, forKey: "lastName")
        userDefaults.set(profile.email, forKey: "email")
        userDefaults.set(profile.phoneCode, forKey: "phoneCode")
        userDefaults.set(profile.mobile, forKey: "mobile")
        userDefaults.set(profile.starMembershipSeed, forKey: "starMembershipSeed")
        userDefaults.set(profile.address, forKey: "address")

        
    }
    
        
      
    
    static func setTypeLevel(level:String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(level, forKey: "Level")
    }
    
    static func getTypeLevel()->String{
          let userDefaults = UserDefaults.standard
        return  userDefaults.value(forKey: "Level") as? String ?? ""
    }
    
    static func setProfileId(Id:String){
        let userDefaults = UserDefaults.standard
        userDefaults.set(Id, forKey: "Id")
    }
    static func getProfileId()->String{
        let userDefaults = UserDefaults.standard
        return  userDefaults.value(forKey: "Id") as? String ?? ""
    }
    
    static func setPushNotification(activated:Bool){
        let userDefaults = UserDefaults.standard
        userDefaults.set(activated, forKey: "PushNotifications")
    }
    
    static func getPushNotification()->Bool{
        let userDefaults = UserDefaults.standard
        if let activated = userDefaults.object(forKey: "PushNotifications") as? Bool{
            return activated
        }
        return true
    }
    
    static func setLoggedIn(){
        let userDefaults = UserDefaults.standard
        userDefaults.set("Logged", forKey: "LoggedIn")
    }
    
    static func clearMobileSessionID(){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: mobileKey)
        userDefaults.removeObject(forKey: "LoggedIn")
    }
    
    static func storeMobileSessionID(sessionID:String){
        var cleanSessionID = sessionID.replacingOccurrences(of: "\"", with: "")
        cleanSessionID = cleanSessionID.replacingOccurrences(of: "\\", with: "")
        let userDefaults = UserDefaults.standard
        userDefaults.set(cleanSessionID, forKey: mobileKey)
        userDefaults.synchronize()
    }
    
    static func storeContactNumber(mobile:String){
        var cleanMobile = mobile.replacingOccurrences(of: "\"", with: "")
        cleanMobile = cleanMobile.replacingOccurrences(of: "\\", with: "")
        contactPhoneNumber = cleanMobile
    }
    
    static func getMobileSessionID()->String?{
        let userDefaults = UserDefaults.standard
        return userDefaults.string(forKey: mobileKey)
    }
}
