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

    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print("Current playerId \(playerId)")
            ServiceInterface.updateUserPlayer(playerId: playerId, handler: nil)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            // Override point for customization after application launch.
            IQKeyboardManager.shared.enable = true
            //ServiceUser.clearMobileSessionID()
            
            //dump(UIFont.fontNames(forFamilyName: "Source Sans Pro"))
            let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
            
            // Replace 'YOUR_APP_ID' with your OneSignal App ID.
            OneSignal.initWithLaunchOptions(launchOptions,
                                            appId: Helper.oneSignalAppID,
                                            handleNotificationAction: nil,
                                            settings: onesignalInitSettings)
            
            OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
            
            // Recommend moving the below line to prompt for push after informing the user about
            //   how your app will use them.
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
            
            return true
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

