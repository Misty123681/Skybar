//
//  ReferController.swift
//  Skybar
//
//  Created by Christopher Nassar on 12/6/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import IQKeyboardManagerSwift

class ReferController: ParentController {

    // MARK:- Properties
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    var phoneCodes:[PhoneCode]!
    
    // MARK:- View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getCountryCodes()
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
     // MARK:- CountryCode api
    func getCountryCodes(){
        GlobalUI.showLoading(self.view)
        
        ServiceInterface.getCountryCodes( handler: { (success, result) in
            GlobalUI.hideLoading()
            if success {
                do{
                    self.phoneCodes = try JSONDecoder().decode(PhoneCodes.self, from: result as! Data)
                }
                catch let error{
                    print(error)
                }
            }else{
                if let res = result as? String{
                    GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                }
            }
            
        })
    }
    
  
    func displayError(){
        let alert = UIAlertController(title: "Missing information", message: "Please fill all required information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
      // MARK:- Refer star method
    @IBAction func submitAction(_ sender: Any) {
        
        if (countryCodeTF.text?.isEmpty)!{
            displayError()
            return
        }
        
        if (phoneTF.text?.isEmpty)!{
            displayError()
            return
        }
        
        if (emailTF.text?.isEmpty)!{
            displayError()
            return
        }
        
        if (nameTF.text?.isEmpty)!{
            displayError()
            return
        }
        
        GlobalUI.showLoading(self.view)
        let phone = countryCodeTF.text!+phoneTF.text!
        ServiceInterface.referAFriend(fullName: nameTF.text!, email: emailTF.text!, mobile: phone) { (success, result) in
            GlobalUI.hideLoading()
            if success{
                GlobalUI.showMessage(title: "Refer A Star", message: "Thank you for referring your friend", cntrl: self)
            }else{
                
            }
        }
    }
 
    
    @IBAction func backAction(_ sender: Any) {
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func countryCodeAction(_ sender: Any) {
        
        if let codes = phoneCodes{
            
            let codesStr = codes.compactMap({$0.phoneCode})
            ActionSheetMultipleStringPicker.show(withTitle: "Country Code", rows: [
                codesStr], initialSelection: [0], doneBlock: {
                    picker, indexes, values in
                    if let arr = values as? [String]{
                        self.countryCodeTF.text = "+"+arr.first!
                    }
            }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
        }
    }

}
