//
//  ParentController.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/23/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class ParentController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    @IBAction func homeAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
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
       
        if let cntrl = getHomeController(){
            self.navigationController?.popViewController(animated: false)
            cntrl.performSegue(withIdentifier: "toHistory", sender: nil)
        }
        
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        
        if let cntrl = getHomeController(){
            self.navigationController?.popViewController(animated: false)
            cntrl.performSegue(withIdentifier: "toSettings", sender: nil)
        }
        
    }
    
    @IBAction func reserveAction(_ sender: Any) {
        
        if let cntrl = getHomeController(){
            self.navigationController?.popViewController(animated: false)
            cntrl.performSegue(withIdentifier: "toReserve", sender: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
