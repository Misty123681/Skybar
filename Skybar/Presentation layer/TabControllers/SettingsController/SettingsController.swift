//
//  SettingsController.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/7/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import OneSignal

class SettingsController: ParentController {
    
    //MARK:- Outlet
    @IBOutlet weak var referAStarBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var editInfoBtn: UIButton!
    @IBOutlet weak var editNameBtn: UIButton!
    @IBOutlet weak var editImgBtn: UIButton!
    @IBOutlet weak var notSwitch: UISwitch!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var mobileLbl: UILabel!
    @IBOutlet weak var fNameLbl: UILabel!
    @IBOutlet weak var lNameLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var membershipLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    
    //MARK:- view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateInfo()
        uiInitize()
    }
    
    fileprivate func uiInitize() {
        self.view.layoutIfNeeded()
        
        self.imageView.layer.cornerRadius = self.imageView.getHeight()/2
        referAStarBtn.layer.masksToBounds = true
        referAStarBtn.layer.cornerRadius = 13
        referAStarBtn.layer.borderWidth = 2
        
      
        if let uiimage = GlobalUI.gradientImage(size: referAStarBtn.bounds.size, color1: color1, color2: color2){
            referAStarBtn.layer.borderColor = UIColor.init(patternImage: uiimage).cgColor
        }
        if let uiimage = GlobalUI.gradientImage(size: notSwitch.bounds.size, color1: color1, color2: color2){
            notSwitch.onTintColor = UIColor.init(patternImage: uiimage)
        }
    }
    
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    //MARK:- Action
    
    /// push notification eanble and disable via button
    ///
    /// - Parameter sender: toggle switch input
    @IBAction func notificationChangeValue(_ sender: UISwitch) {
        ServiceUser.setPushNotification(activated: sender.isOn)
        OneSignal.setSubscription(sender.isOn)
    }
    
    fileprivate func setEditButton(_ title:String,_ bool:Bool) {
        editBtn.setTitle(title, for: .normal)
        editInfoBtn.isHidden = bool
        editNameBtn.isHidden = bool
        editImgBtn.isHidden = bool
    }
    
    @IBAction func editAction(_ sender: Any) {
        if editBtn.tag == 0{
            editBtn.tag = 1
             setEditButton("DONE", false)
        }else{
            editBtn.tag = 0
            setEditButton("EDIT INFO", true)
            
        }
    }
    
    
    
    /// logout and clear mobile session ID
    
    @IBAction func logoutAction(_ sender: Any) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            ServiceUser.clearMobileSessionID()
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func editImageAction(_ sender: Any) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.imageView.image = image
            if let data = image.jpegData(compressionQuality: 0.5){
                self.uploadImage(data)
            }
        }
    }
    

    /// upload image with base 64
    ///
    /// - Parameter data: input data bytes
    func uploadImage(_ data:Data){
        let strBase64 = data.base64EncodedString(options: .lineLength64Characters)
        ServiceInterface.uploadImage(imageData: strBase64, handler: { (success, result) in
            if success {
            }else{
                if (result as? String) != nil{}
            }
        })
    }
    
    
    /// set profile info
    func populateInfo(){
        
        notSwitch.isOn = ServiceUser.getPushNotification()
        
        if let profile = ServiceUser.profile{
            fNameLbl.text = profile.firstName
            lNameLbl.text = profile.lastName
            emailLbl.text = profile.email
            mobileLbl.text = profile.phoneCode!+profile.mobile
            addressLbl.text = profile.address
            levelLbl.text = profile.level
            membershipLbl.text = "Membership STAR \(String(format: "%04d", profile.starMembershipSeed))"
            notSwitch.isOn = ServiceUser.getPushNotification()
        }else{
            let userDefaults = UserDefaults.standard
            fNameLbl.text = userDefaults.value(forKey: "firstName") as? String ?? ""
            lNameLbl.text = userDefaults.value(forKey: "lastName")as? String ?? ""
            emailLbl.text = userDefaults.value(forKey: "email")as? String ?? ""
            let mobile = userDefaults.value(forKey: "mobile")as? String ?? ""
            let code =  userDefaults.value(forKey: "phoneCode")as? String ?? ""
            mobileLbl.text = code + mobile
            addressLbl.text = userDefaults.value(forKey: "address") as? String ?? ""
            levelLbl.text = ServiceUser.getTypeLevel()
            let membership = userDefaults.value(forKey: "starMembershipSeed") as? Int ?? 0
            membershipLbl.text = "Membership STAR \(String(format: "%04d", membership))"
        }
    }
    

    /// get profile pick
    func getImage(){
        let id = ServiceUser.getProfileId()
        ServiceInterface.getImage(imageName: "\(id).jpg", handler: { (success, result) in
            
            if success {
                if let data = result as? Data{
                    OperationQueue.main.addOperation {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }else{
                if let res = result as? String{
                    GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                }
            }
        })
    }
    
}
