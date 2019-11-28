//
//  ResendController.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/23/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class ResendController: ParentController {

    // MARK:- Outlets
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    var phoneCodes:[PhoneCode]!
    
    // MARK:- view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getCountryCodes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneNumberTF.becomeFirstResponder()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    // MARK:-  get country code
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
    
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendCode(_ sender: Any) {
        if (countryCodeTF.text?.isEmpty)!{
            GlobalUI.showMessage(title: "Missing Field", message: "Please enter country code", cntrl: self)
            return
        }
        
        if (phoneNumberTF.text?.isEmpty)!{
            GlobalUI.showMessage(title: "Missing Field", message: "Please enter mobile number", cntrl: self)
            return
        }
        
        phoneNumberTF.resignFirstResponder()
        GlobalUI.showLoading(self.view)
        let mobileNumber = countryCodeTF.text! + phoneNumberTF.text!
        
        ServiceInterface.resendCode(mobileNumber: mobileNumber, handler: { (success, result) in
            GlobalUI.hideLoading()
            if success {
                if let data = result as? Data{
                    if var code = String(data: data, encoding: String.Encoding.utf8){
                        code = code.replacingOccurrences(of: "\"", with: "")
                        if(!code.isEmpty){
                            GlobalUI.showMessage(title: "Code Sent", message: "Code sent to the mobile number provided", cntrl: self)
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            GlobalUI.showMessage(title: "Error", message: "Code could not be sent", cntrl: self)
                        }
                    }
                }
            }else{
                if let res = result as? String{
                    GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                }
            }
        })
        
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
