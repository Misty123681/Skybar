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
        delObj.customNavigationVC.viewControllers = [homeVC]
        delObj.window?.rootViewController = delObj.customNavigationVC

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
        delObj.customNavigationVC.viewControllers = [homeVC]
        delObj.window?.rootViewController = delObj.customNavigationVC
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "SettingsController") as! SettingsController
        delObj.customNavigationVC.viewControllers = [homeVC]
        delObj.window?.rootViewController = delObj.customNavigationVC
    }
    
    @IBAction func reserveAction(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "ReserveController") as! ReserveController
        delObj.customNavigationVC.viewControllers = [homeVC]
        delObj.window?.rootViewController = delObj.customNavigationVC
    }
    
    @IBAction func setCurrentTab(_ sender: UIButton) {
        
    }

}
