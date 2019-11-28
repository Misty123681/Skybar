//
//  LoginControllerViewController.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/23/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class LoginController: ParentController {

    // MARK:- Outlets
    @IBOutlet weak var codeTF: UITextField!
    
     // MARK:- view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        codeTF.becomeFirstResponder()
    }

      // MARK:- login 
    @IBAction func activateKey(_ sender: Any) {
        
        if (codeTF.text?.isEmpty)!{
            GlobalUI.showMessage(title: "Missing Field", message: "Please enter code", cntrl: self)
            return
        }
        
        codeTF.resignFirstResponder()
        GlobalUI.showLoading(self.view)
        ServiceInterface.activateAccount(key: codeTF.text!) { (success, result) in
            GlobalUI.hideLoading()
            if success {
                if let data = result as? Data{
                    if let resultStr = String(data: data, encoding: String.Encoding.utf8){
                        if(!resultStr.isEmpty){
                            ServiceUser.storeMobileSessionID(sessionID: resultStr)
                            OperationQueue.main.addOperation({
                                self.performSegue(withIdentifier: "toProfile", sender: nil)
                            })
                        }else{
                            GlobalUI.showMessage(title: "Error", message: "Code could not be validated", cntrl: self)
                        }
                    }else{
                        GlobalUI.showMessage(title: "Error", message: "Code could not be validated", cntrl: self)
                    }
                }
            }else{
                if let res = result as? String{
                    GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
  
}
