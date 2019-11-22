//
//  CardController.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/3/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import WebKit

class CardController: ParentController {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cardIV: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
       
        if let url = URL(string:"http://skybarstar.com/privacy.html"){
               webView.load(URLRequest(url:url))
            
        }
        
        if let profile = ServiceUser.profile{
            nameLbl.text = profile.firstName+" "+profile.lastName
            levelLbl.text = "STAR \(String(format: "%04d", profile.starMembershipSeed))"
            
        }
         getImage()
    }
    
    @IBAction func sendMeKeyAction(_ sender: Any) {
        if checkBtn.tag == 1{
            GlobalUI.showMessage(title: "Cannot proceed", message: "Please agree to the terms & conditions", cntrl: self)
            return
        }
        
        ServiceInterface.acceptTerms(handler: nil)
        self.performSegue(withIdentifier: "toKey", sender: nil)
    }
    
    @IBAction func popAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkAction(_ sender: Any) {
        if checkBtn.tag == 0{
            checkBtn.tag = 1
            checkBtn.setBackgroundImage(nil, for: .normal)
        }else{
            checkBtn.tag = 0
            checkBtn.setBackgroundImage(UIImage(named:"checked"), for: .normal)
        }
    }
    
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    

}
