//
//  ServiceInterface.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/29/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class ServiceInterface: NSObject {
    //static let hostURL = "http://40.76.73.185/skybar/UserAppService/"
   
    static let hostURL = "http://40.76.73.185/SkybarstarTest/UserAppService/" // testing
  //static let hostURL = "http://skybarstar.com/UserAppService/" // live
    static let cache = NSCache<AnyObject, AnyObject>()
    
    static func activateAccount(key:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)ActivateYourAccount"
        var params = [String:Any]()
        params["key"] = key
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func resendCode(mobileNumber:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)ResendCode"
        var params = [String:Any]()
        params["mobileNumber"] = mobileNumber
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func setAddressLocation(longitude:Double,latitude:Double,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)SetAddresslocation"
        var params = [String:Any]()
        params["locationInfo"] = "\(longitude)-\(latitude)"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func acceptTerms(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)AcceptTerms"
        var params = [String:Any]()
        params["accept"] = true
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getImage(imageName:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetImage"
        
        if let data = cache.object(forKey: imageName as AnyObject){
            if let handler = handler{
                handler(true,data)
                return
            }
        }
        
        var params = [String:Any]()
        params["imageKey"] = imageName
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:params) { (success, result) in
            if success{
                if let result = result as? Data{
                    cache.setObject(result as AnyObject, forKey: imageName as AnyObject)
                }
            }
            if let handler = handler{
                handler(success,result)
            }
        }
    }

    static func uploadImage(imageData:String,handler:APICompletionHandler?){
        
        cache.removeAllObjects()
        
        let fullPath = "\(hostURL)UploadProfilePhoto"
        var params = [String:Any]()
        params["imageData"] = imageData
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    //UserName pmo@cspsolutions.com
    //password Csp00123@
    static func isValidMobileUser(username:String,password:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)isValidMobileUser"
        var params = [String:Any]()
        params["userName"] = username
        params["password"] = password
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getCurrentEvents(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetCurrentEvents"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getCurrentSkyStatus(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetCurrentSkyStatus"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getMyResevations(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetMyReservations"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getUserProfileInfo(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetUserProfileInfo"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getVisitsCharts(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetVisitsChart"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getReservationNumber(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)ReservationNumber"
       
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getTimelineInfo(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetTimelineInfo"
        
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
 
    
    static func setRating(visitID:String,rating:Float,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)RateVisitDetailed"
        
        var params = [String:Any]()
        params["visitID"] = visitID
        params["VisitRatingValue"] = rating
        
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    static func thisWasNotMeAPI(visitID:String,rating:Float,handler:APICompletionHandler?){
//        let fullPath = "\(hostURL)RateVisit"
//
//        var params = [String:Any]()
//        params["visitID"] = visitID
//        params["rating"] = rating
//
//        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
//            if let handler = handler{
//                handler(success,result)
//            }
//        }
    }
    
    static func getReservationRules(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetReservationsRules"
        
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getShareLink(eventID:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)ShareEventLink"
        var params = [String:Any]()
        params["eventID"] = eventID
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func GetVisitBill(visitID:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetVisitBill"
        var params = [String:Any]()
        params["visitID"] = visitID
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func activateSkyKey(key:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)ActivateSkykey"
        var params = [String:Any]()
        params["key"] = key
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getVisitsHistory(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetVisitsHistory"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getPrivileges(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetPrivileges"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func logoutMobile(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)LogoutMobile"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func reserveEvent(eventID:String,type:Int,guests:Int,budget:Float?,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)ReserveEvent" //Type/Guests/EventID
        var params = [String:Any]()
        params["eventID"] = eventID
        params["type"] = type
        params["guests"] = guests
        if let budget = budget{
            params["budget"] = budget
        }
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func updateUserInfo(profile:ProfileObject,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)UpdateUserProfileInfo"
        var params = [String:Any]()
        params["profile"] = profile.toDictionary()
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func referAFriend(fullName:String,email:String,mobile:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)ReferFriend"
        var params = [String:Any]()
        params["FullName"] = fullName
        params["Email"] = email
        params["Mobile"] = mobile
        
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getStarGuests(eventID:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetStarGuests"
        var params = [String:Any]()
        params["eventID"] = eventID
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:params,bodyparams:nil ) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func addGuest(fullName:String,eventID:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)AddGuest"
        var params = [String:Any]()
        params["GuestFullName"] = fullName
        params["Event_ID"] = eventID
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func removeGuest(guestID:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)RemoveGuest"
        var params = [String:Any]()
        params["GuestID"] = guestID
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getCountryCodes(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetAllCountriesPhoneCodes"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getInstagramMedia(token:String,handler:APICompletionHandler?){
        let fullPath = "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(token)"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,addMobileSession:false,uriparams:nil,bodyparams: nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func updateUserPlayer(playerId:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)UpdateUserPlayerID"
        var params = [String:Any]()
        params["playerID"] = playerId
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func getCareemLinks(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetCareemUrlLinks"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func logError(error:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)LogError"
        var params = [String:Any]()
        params["errorInfo"] = error
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func setSeenReservationNotifications(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)SetSeenReservationNotifications"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func editReservation(reservationId:String,type:Int,guests:Int,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)EditReservation"
        var params = [String:Any]()
        params["reservationID"] = reservationId
        params["type"] = type
        params["guests"] = guests
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func cancelReservation(reservationId:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)CancelReservation"
        var params = [String:Any]()
        params["reservationID"] = reservationId
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
              
            }
        }
    }
    
    static func getZonesByBudget(budget:Float,numberOfGuests:Int,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetZonesByBudget"
        var params = [String:Any]()
        params["budget"] = budget
        params["numberOfGuests"] = numberOfGuests

        ServiceEngine.sharedInstance.startTaskCancelleable(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    static func resizeImage(imageKey:String,width:Float,height:Float,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetImageResized"
        var params = [String:Any]()
        params["imagekey"] = imageKey
        params["width"] = width
        params["height"] = height
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    
}
