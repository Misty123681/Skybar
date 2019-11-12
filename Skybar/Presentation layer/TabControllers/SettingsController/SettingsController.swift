//
//  SettingsController.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/7/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import OneSignal

class SettingsController: ParentController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
    
    var imagePicker = UIImagePickerController()
    
    //MARK:- view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        populateInfo()
        self.view.layoutIfNeeded()
        self.imageView.layer.cornerRadius = self.imageView.getHeight()/2
        
        referAStarBtn.layer.masksToBounds = true
        referAStarBtn.layer.cornerRadius = 13
        referAStarBtn.layer.borderWidth = 2
        
        var color1 = CIColor(color:UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 238.0/255.0, alpha: 1))
        var color2 = CIColor(color:UIColor(red: 16.0/255.0, green: 60.0/255.0, blue: 153.0/255.0, alpha: 1))
        if let uiimage = GlobalUI.gradientImage(size: referAStarBtn.bounds.size, color1: color1, color2: color2){
            referAStarBtn.layer.borderColor = UIColor.init(patternImage: uiimage).cgColor
        }
        
        color2 = CIColor(color:UIColor(red: 28.0/255.0, green: 165.0/255.0, blue: 238.0/255.0, alpha: 1))
        color1 = CIColor(color:UIColor(red: 16.0/255.0, green: 60.0/255.0, blue: 153.0/255.0, alpha: 1))
        if let uiimage = GlobalUI.gradientImage(size: notSwitch.bounds.size, color1: color1, color2: color2){
            notSwitch.onTintColor = UIColor.init(patternImage: uiimage)
        }
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    //MARK:- Action
    @IBAction func notificationChangeValue(_ sender: UISwitch) {
        ServiceUser.setPushNotification(activated: sender.isOn)
        OneSignal.setSubscription(sender.isOn)
    }
    
    @IBAction func editAction(_ sender: Any) {
        if editBtn.tag == 0{
            editBtn.tag = 1
            editBtn.setTitle("DONE", for: .normal)
            editInfoBtn.isHidden = false
            editNameBtn.isHidden = false
            editImgBtn.isHidden = false
        }else{
            editBtn.tag = 0
            editBtn.setTitle("EDIT INFO", for: .normal)
            editInfoBtn.isHidden = true
            editNameBtn.isHidden = true
            editImgBtn.isHidden = true
        }
    }
    
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
        let alert = UIAlertController(title: "Change picture", message: nil, preferredStyle: .actionSheet)
        let chooseAction = UIAlertAction(title: "Photo album", style: .default) { (action) in
            self.getImageFromGallery()
        }
        let captureAction = UIAlertAction(title: "Take picture", style: .default) { (action) in
            self.captureImage()
        }
        alert.addAction(chooseAction)
        alert.addAction(captureAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:- Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
        if let data = image?.jpegData(compressionQuality:0.5){
            uploadImage(data)
        }
    }
    
    
    func uploadImage(_ data:Data){
        let strBase64 = data.base64EncodedString(options: .lineLength64Characters)
        ServiceInterface.uploadImage(imageData: strBase64, handler: { (success, result) in
            if success {
            }else{
                if let res = result as? String{
                    //GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                }
            }
        })
    }
    
    func captureImage(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .front
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func getImageFromGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
  
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
