//
//  HomeController.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/23/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class EditPageButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 13
        self.backgroundColor = whiteClr
        self.layer.borderWidth = 1
        self.layer.borderColor = grayColor.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor(red:1, green:1, blue:1, alpha:0.73).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 27
    }
}

class ProfileController: ParentController  {
    
    // MARK:- IBOutlets
    @IBOutlet weak var fNameLbl: UILabel!
    @IBOutlet weak var lNameLbl: UILabel!
    @IBOutlet weak var membershipLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var contactBG: UIView!
    @IBOutlet weak var editPicBtn: UIButton!
    @IBOutlet weak var editNameBtn: UIButton!
    @IBOutlet weak var editContactBtn: UIButton!
    @IBOutlet weak var editInfoBtn: UIButton!
    @IBOutlet weak var confirmInfoBtn: WhiteButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    
     // MARK:- Variable
    var firstLoad = true
   
     // MARK:- View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmInfoBtn.addTarget(self, action: #selector(self.toCardPreview), for: .touchUpInside)
        let layer = UIView(frame: imageView.bounds)
        layer.layer.shadowOffset = CGSize.zero
        layer.layer.shadowColor = UIColor(red:1, green:1, blue:1, alpha:0.65).cgColor
        layer.layer.shadowOpacity = 1
        layer.layer.shadowRadius = 9
        self.view.addSubview(layer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
        imageView.layer.cornerRadius =  imageView.frame.size.height/2
        confirmInfoBtn.layer.borderColor = whiteClr.cgColor
        confirmInfoBtn.layer.borderWidth = 2
        getProfileInfo()
    }
   
    
    // MARK:- upload image with base64
    func uploadImage(_ data:Data){
        let strBase64 = data.base64EncodedString(options: .lineLength64Characters)
        
        ServiceInterface.uploadImage(imageData: strBase64, handler: { (success, result) in
            
            if success {
                self.getProfileInfo()
            }else{
                if (result as? String) != nil{
                }
            }
        })
    }
       // MARK:- Capture image
   
    
    
    
    @IBAction func toImageAction(_ sender: Any) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.imageView.image = image
            if let data = image.jpegData(compressionQuality: 0.5){
                self.uploadImage(data)
            }
        }
    }
    @IBAction func editInfoAction(_ sender: Any) {
        editNameBtn.isHidden = false
        editPicBtn.isHidden = false
        editContactBtn.isHidden = false
        contactBG.backgroundColor = UIColor.init(white: 0, alpha: 0.38)
        editInfoBtn.isEnabled = false
        fNameLbl.backgroundColor = UIColor(white: 0, alpha: 0.38)
        lNameLbl.backgroundColor = UIColor(white: 0, alpha: 0.38)
        
        confirmInfoBtn.tag = 1
        confirmInfoBtn.layoutSubviews()
        confirmInfoBtn.setTitleColor(.white, for: .normal)
        confirmInfoBtn.setTitle("DONE", for: .normal)
        editInfoBtn.setTitle("YOUR INFO", for: .normal)
        confirmInfoBtn.backgroundColor = .clear
        confirmInfoBtn.removeTarget(self, action:  #selector(self.toCardPreview), for: .touchUpInside)
        confirmInfoBtn.addTarget(self, action: #selector(self.holdEditInformation), for: .touchUpInside)
    }
    
    @objc func holdEditInformation(){
        editNameBtn.isHidden = true
        editPicBtn.isHidden = true
        editContactBtn.isHidden = true
        editInfoBtn.isEnabled = true
        fNameLbl.backgroundColor = .clear
        lNameLbl.backgroundColor = .clear
        contactBG.backgroundColor = .clear
        confirmInfoBtn.tag = 0
        confirmInfoBtn.layoutSubviews()
        confirmInfoBtn.setTitleColor(.black, for: .normal)
        confirmInfoBtn.setTitle("CONFIRM YOUR INFO", for: .normal)
         editInfoBtn.setTitle("EDIT YOUR INFO", for: .normal)
        confirmInfoBtn.backgroundColor = .white
        confirmInfoBtn.removeTarget(self, action:  #selector(self.holdEditInformation), for: .touchUpInside)
        confirmInfoBtn.addTarget(self, action: #selector(self.toCardPreview), for: .touchUpInside)
    }
    
    @objc func toCardPreview(){
        self.performSegue(withIdentifier: "toCard", sender: nil)
    }
    

    func populateInfo(){
           // MARK:- show data
        if let profile = ServiceUser.profile{
            fNameLbl.text = profile.firstName
            lNameLbl.text = profile.lastName
            emailLbl.text = profile.email
            phoneLbl.text = profile.phoneCode ?? "" + profile.mobile 
            addressLbl.text = profile.address
            levelLbl.text = profile.level
            membershipLbl.text = "STAR \(String(format: "%04d", profile.starMembershipSeed))"
        }
        
        if firstLoad{
            getImage()
            firstLoad = false
        }
    }
    
       // MARK:- get image
    func getImage(){
        if let profile = ServiceUser.profile{
            ServiceInterface.getImage(imageName: "\(profile.id).jpg", handler: { (success, result) in
               
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
    
    func getProfileInfo(){
        self.view.layoutIfNeeded()
        GlobalUI.showLoading(self.view)
        
        ServiceInterface.getUserProfileInfo(handler: { (success, result) in
            GlobalUI.hideLoading()
            if success {
                do{
                    let profile = try JSONDecoder().decode(ProfileObject.self, from: result as! Data)
                    ServiceUser.profile = profile
                   
                  
                    OperationQueue.main.addOperation {
                        self.populateInfo()
                    }
                }
                catch let error {
                    print(error.localizedDescription)
                }
            }else{
                if let res = result as? String{
                    GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toInfo" {
            let cntrl = segue.destination as! EditNameController
            cntrl.directInfo = true
        }
    }

}

