//
//  EditNameController.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/24/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class EditNameController: ParentController {
    
    // MARK:- Outlets
    var directInfo = false
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    
    // MARK:-view Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastNameTF.text = ServiceUser.profile?.lastName
        lastNameTF.placeholder = ServiceUser.profile?.lastName
        firstNameTF.text = ServiceUser.profile?.firstName
        firstNameTF.placeholder = ServiceUser.profile?.firstName
        let tap = UITapGestureRecognizer(target: self, action: #selector(displayTitles))
        titleLbl.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if directInfo {
            directInfo = false
            self.performSegue(withIdentifier: "toInfo", sender: nil)
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        GlobalUI.showLoading(self.view)
        
        let profile = ServiceUser.profile
        profile?.firstName = firstNameTF.text!
        profile?.lastName = lastNameTF.text!
        
        ServiceInterface.updateUserInfo(profile: profile!,handler: { (success, result) in
            GlobalUI.hideLoading()
            if success {
                if let _ = self.navigationController{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
            }else{
                if let res = result as? String{
                    GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                }
            }
        })
    }
    
    

    @IBAction func nextAction(_ sender: Any) {
    }
    
    
    @objc func displayTitles(){
        ActionSheetMultipleStringPicker.show(withTitle: "Pick your title", rows: [
            ["Mr", "Mrs", "Ms", "Dr"]], initialSelection: [0], doneBlock: {
                picker, indexes, values in
                if let arr = values as? [String]{
                    self.titleLbl.text = arr.first!
                }
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
    }

}
