//
//  ParentController.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/23/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class ParentController: UIViewController {
    
    // MARK: - outlets
    
    let delObj = UIApplication.shared.delegate as! AppDelegate
    var currentTab = 0
    
    // MARK:- View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
     // MARK:- Actions & methods
    
    @IBAction func homeAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        delObj.navigationVc.viewControllers = [homeVC]
        delObj.window?.rootViewController = delObj.navigationVc

    }
    
    func getHomeController()->HomeController?{
        if let navController = self.navigationController{
            for cntr in navController.viewControllers{
                if cntr is HomeController{
                    return cntr as? HomeController
                }
            }
        }
    
        return nil
    }
    
    @IBAction func historyAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HistoryController") as! HistoryController
        delObj.navigationVc.viewControllers = [homeVC]
        delObj.window?.rootViewController = delObj.navigationVc
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "SettingsController") as! SettingsController
        delObj.navigationVc.viewControllers = [homeVC]
        delObj.window?.rootViewController = delObj.navigationVc
    }
    
    @IBAction func reserveAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "ReserveController") as! ReserveController
        delObj.navigationVc.viewControllers = [homeVC]
        delObj.window?.rootViewController = delObj.navigationVc
    }
    
    @IBAction func setCurrentTab(_ sender: UIButton) {
        
    }

}
