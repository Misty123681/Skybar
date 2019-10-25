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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,OSSubscriptionObserver {

    var window: UIWindow?
    var customNavigationVC:UINavigationController!
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
    
   
    
    fileprivate func oneSignalCallbackHandler(_ launchOptions: [UIApplication.LaunchOptionsKey : Any]?, _ onesignalInitSettings: [String : Bool]) {
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            
            print("Received Notification: \(String(describing: notification!.payload.notificationID))")
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload = result!.notification.payload
            
            var fullMessage = payload.body
            print("Message = \(String(describing: fullMessage))")
            
            if payload.additionalData != nil {
                if payload.title != nil {
                    let messageTitle = payload.title
                    print("Message Title = \(messageTitle!)")
                }
                
                let additionalData = payload.additionalData
                if additionalData?["Event"] != nil {
                    fullMessage = fullMessage! + "\nPressed ButtonID: \(String(describing: additionalData!["EventI"]))"
                }
            }
        }
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: Helper.oneSignalAppID,
                                        handleNotificationReceived: notificationReceivedBlock,
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//
//        let state = UIApplication.shared.applicationState
//        switch state {
//        case .active:
//              print("foreground")
//        case .inactive:
//              print("inactive")
//        case .background:
//            print("background")
//        }
//

    
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
            customNavigationVC = UINavigationController(rootViewController: homeVC)
        } else {
            let landingVC = storyboard.instantiateViewController(withIdentifier: "LandingController") as! LandingController
            customNavigationVC = UINavigationController(rootViewController: landingVC)
        }
        customNavigationVC.isNavigationBarHidden = true
        self.window?.rootViewController = customNavigationVC
        return true
    }
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        debugPrint("Received: \(userInfo)")
        
        let state = UIApplication.shared.applicationState
        switch state {
        case .active:
              print("foreground")
        case .inactive:
            print("inactive")
        case .background:
             print("background")
        }
   
        
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

