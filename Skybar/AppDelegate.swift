//
//  AppDelegate.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/20/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import OneSignal
import Fabric
import Crashlytics

protocol GuestPage:class{
    func guestNotification()
}

protocol HomePage:class{
    func homeNotification()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,OSSubscriptionObserver {

    var window: UIWindow?
    var navigationVc:UINavigationController!
    weak var delegate: GuestPage?
    weak var delegateHome: HomePage?
    
    //MARK:- delegate method for onesignal
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(String(describing: stateChanges))")
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            ServiceInterface.updateUserPlayer(playerId: playerId, handler: nil)
        }
    }
    
   
    //MARK:- Callback on Notification Tapped
    fileprivate func oneSignalCallbackHandler(_ launchOptions: [UIApplication.LaunchOptionsKey : Any]?, _ onesignalInitSettings: [String : Bool]) {
        
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            
            print("Received Notification: \(String(describing: notification!.payload.notificationID))")
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload = result!.notification.payload
            print(payload.additionalData)
            let payload1: NSDictionary = payload.additionalData as NSDictionary
            print(payload1)
            
            let fullMessage = payload.body
            print("Message = \(String(describing: fullMessage))")
            
            var screenId = ""
            if payload.additionalData != nil {
                if let screenID = payload.additionalData["ScreenId"] {
                    screenId =  "\(screenID)"
                    print("Message Title = \(screenID)")
                }
            }
            
                switch screenId {
                case "HomeScreen":
                    self.navigateToHome()
                case "RateUsScreen":
                    self.navigateToMySKY()
                case "MySkyScreen":
                    self.navigateToMySKY()
                case "GuestListScreen":
                    self.navigateToGuestPage()
                default:
                    print("Home")
                }
            

        }
        
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: Helper.oneSignalAppID,
                                        handleNotificationReceived: notificationReceivedBlock,
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
      
        
            IQKeyboardManager.shared.enable = true

           let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
            oneSignalCallbackHandler(launchOptions, onesignalInitSettings)
        
           OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
            OneSignal.promptForPushNotifications(userResponse: { accepted in
                print("User accepted notifications: \(accepted)")
            })
        
            if let playerId = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId{
                ServiceInterface.updateUserPlayer(playerId: playerId, handler: nil)
            }
        
            OneSignal.add(self as OSSubscriptionObserver)
            Fabric.with([Crashlytics.self])
        
        
    
        if let window = UIApplication.shared.windows.first {
            window.backgroundColor = .white
        }
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if ServiceUser.loggedIn(){
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
            navigationVc = UINavigationController(rootViewController: homeVC)
            
        } else {
            let landingVC = storyboard.instantiateViewController(withIdentifier: "LandingController") as! LandingController
             navigationVc = UINavigationController(rootViewController: landingVC)
        }
        navigationVc.isNavigationBarHidden = true
        self.window?.rootViewController = navigationVc
        return true
    }
    
    
    func navigateToHome(){
        
        if let topVC = UIApplication.getTopViewController() {
            if let vc  = topVC as? HomeController{
                print("its Home page")
                self.delegateHome = vc
                delegateHome?.homeNotification()
            }else{
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vC = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
                navigationVc = UINavigationController(rootViewController: vC)
                navigationVc.isNavigationBarHidden = true
                self.window?.rootViewController = navigationVc
            }
        }
      
    }
    func navigateToMySKY(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vC = storyboard.instantiateViewController(withIdentifier: "HistoryController") as! HistoryController
        navigationVc = UINavigationController(rootViewController: vC)
        navigationVc.isNavigationBarHidden = true
        self.window?.rootViewController = navigationVc
    }
    
    func navigateToGuestPage(){
        if let topVC = UIApplication.getTopViewController() {
            if let vc  = topVC as? GuestListController{
                print("its guest page")
                self.delegate = vc
                delegate?.guestNotification()
            }else{
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vC = storyboard.instantiateViewController(withIdentifier: "GuestListController") as! GuestListController
                navigationVc.isNavigationBarHidden = true
                self.delegate = vC
                delegate?.guestNotification()
                self.window?.rootViewController = vC
                self.window?.makeKeyAndVisible()
            }
        }
       
    }
    
  
    //MARK:- method get called on notification taped
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
        debugPrint("Received: \(userInfo)")
       let dict = userInfo as! [String: Any]
        print(dict)
       
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
