//
//  ServiceInterface.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/29/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class ServiceInterface: NSObject {
    
     // MARK:- Development
    
    static let hostURL = "http://192.119.87.9/SkybarstarTest/UserAppService/" // testing
    
    // MARK:- Distribution
 
   // static let hostURL = "http://40.76.73.185/SkybarstarTest/UserAppService/"
    
  static let cache = NSCache<AnyObject, AnyObject>()
 // static let hostURL = "http://skybarstar.com/UserAppService/" // live
//    func rateExperience(user: userEventExperienceModel,completion:@escaping (NSDictionary) -> ()){
//        if let url = URL(string: "\(ServiceInterface.hostURL)GetTimelineInfo") {
//            let request = NSMutableURLRequest( url: url as URL)
//            let registerDict = ["EventId": user.EventId, "musicRatingValue": user.musicRatingValue!, "ServiceRatingValue": user.ServiceRatingValue!, "AtmosphereRatingValue": user.AtmosphereRatingValue!, "OverAllRatingValue": user.OverallRatingValue!] as [String : Any]
//                print(registerDict)
//            let jsonData = try! JSONSerialization.data(withJSONObject: user, options: JSONSerialization.WritingOptions.init(rawValue: 0))
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.httpBody = jsonData
//            let task = URLSession.shared.dataTask(with: request as URLRequest) {
//                data, response, error in
//                do{
//                    if let data = data,
//                        let jsonString =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
//                        , error == nil {
//                        completion(jsonString)
//                    } else {
//                        print("error=\(error!.localizedDescription)")
//                        let errorDict = ["error_status":true,"message":error!.localizedDescription] as [String : Any]
//                        completion(errorDict as NSDictionary)
//
//                    }
//                }
//                catch{
//                    print("error=\(error.localizedDescription)")
//                    let errorDict = ["error_status":true,"message":error.localizedDescription] as [String : Any]
//                    completion(errorDict as NSDictionary)
//
//                }
//
//            }
//            task.resume()
//        }
//
//    }
    // MARK:- Login api
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
    
    // MARK:- Rating Code
static func submitUserRating(eventId:String,musicRatingValue:String,serviceRatingValue:String,atmosphereRatingValue:String,overallRatingValue:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)RateExperience"
        var params = [String:Any]()
        params["EventID"] = eventId
    params["EventID"] = eventId
    params["MusicRatingValue"] = musicRatingValue
    params["ServiceRatingValue"] = serviceRatingValue
    params["AtmosphereRatingValue"] = atmosphereRatingValue
    params["OverallRatingValue"] = overallRatingValue
     
    debugPrint(params)

     ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params){ (success, result) in
            if let handler = handler{
                handler(success,result) 
            }
        }
    }

     // MARK:-  Resend code
    static func resendCode(mobileNumber:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)ResendCode"
        var params = [String:Any]()
        params["mobileNumber"] = mobileNumber
        print(params)
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:params) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    // MARK:-  set address location
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
       // MARK:- Terms and conditions
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
    
       // MARK:- download image
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

       // MARK:- Upload profile photo
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
    
    // MARK:- IsValidMobileUser
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
    
     // MARK:- Current Events
    static func getCurrentEvents(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetCurrentEvents"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
      // MARK:- Current sky status
    static func getCurrentSkyStatus(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetCurrentSkyStatus"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
       // MARK:- Get my all reservation
    static func getMyResevations(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetMyReservations"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    
    // MARK:-  Get user profile info
    static func getUserProfileInfo(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetUserProfileInfo"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    
    // MARK:-  Chart info
    static func getVisitsCharts(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetVisitsChart"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    // MARK:- Reservation number
    static func getReservationNumber(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)ReservationNumber"
       
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
     // MARK:- History
    static func getTimelineInfo(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetTimelineInfo"
        
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    static func userEventExperience(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetTimelineInfo"
        
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
 
     // MARK:-  Rate us
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
    
    // MARK:- this was not me
    static func thisWasNotMeAPI(caseNumber: Bool ,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)ReportCase"
        var params = [String:Any]()
        params["caseNumber"] = "1"
        debugPrint(params)
        print(params)

        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
            debugPrint(result)
             print(result)
            
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    // MARK:- Reservation rules
    static func getReservationRules(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetReservationsRules"
        
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    // MARK:- share event link
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
    
    // MARK:- visit bill
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
    
    // MARK:- Active sky key
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
    
    // MARK:- Get visit history
    static func getVisitsHistory(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetVisitsHistory"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    // MARK:- Get privileges
    static func getPrivileges(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetPrivileges"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    // MARK:- Logout mobile
    static func logoutMobile(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)LogoutMobile"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,uriparams:nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
       // MARK:-  Reserve Event
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
    
       // MARK:-  update user profile info
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
    
       // MARK:- Refer friend
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
    
       // MARK:-  Get star
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
    
       // MARK:-  Add guest
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
    
       // MARK:-  delete guest
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
    
       // MARK:-  Get all countries codes
    static func getCountryCodes(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetAllCountriesPhoneCodes"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    // MARK:- Instagram feeds
    static func getInstagramMedia(token:String,handler:APICompletionHandler?){
        let fullPath = "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(token)"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .GET,addMobileSession:false,uriparams:nil,bodyparams: nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    // MARK:-  Update player Id
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
    
    // MARK:- Get Careem link
    static func getCareemLinks(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)GetCareemUrlLinks"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    // MARK:- Log Error
    static func logError(error:String,handler:APICompletionHandler?){
        let fullPath = "\(hostURL)LogError"
        var params = [String:Any]()
        params["errorInfo"] = error
//        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: params) { (success, result) in
//            if let handler = handler{
//                handler(success,result)
//            }
//        }
    }
    
    // MARK:- SetSeenReservationNotifications
    static func setSeenReservationNotifications(handler:APICompletionHandler?){
        let fullPath = "\(hostURL)SetSeenReservationNotifications"
        ServiceEngine.sharedInstance.startTask(pathURL: fullPath, httpMethod: .POST,uriparams:nil,bodyparams: nil) { (success, result) in
            if let handler = handler{
                handler(success,result)
            }
        }
    }
    
    // MARK:- Modify reservation
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
    
    // MARK:- cancel reservation
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
    
    // MARK:- Get Zone area by budget
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
    
    // MARK:- get image by sized
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
