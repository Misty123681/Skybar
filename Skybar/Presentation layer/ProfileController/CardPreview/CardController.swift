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
        // Do any additional setup after loading the view.
        getImage()
        
        if let url = URL(string:"http://skybarstar.com/privacy.html"){
            webView.load(URLRequest(url:url))
        }
        
        if let profile = ServiceUser.profile{
            nameLbl.text = profile.firstName+" "+profile.lastName
            levelLbl.text = "STAR \(String(format: "%04d", profile.starMembershipSeed))"
            
//            let size = memberLbl.intrinsicContentSize
//            let color1 = CIColor(color:UIColor(red: 255.0/255.0, green: 150.0/255.0, blue: 120.0/255.0, alpha: 1))
//            let color2 = CIColor(color:UIColor(red: 196.0/255.0, green: 172.0/255.0, blue: 84.0/255.0, alpha: 1))
//            if let uiimage = GlobalUI.gradientImage(size: size, color1: color1, color2: color2){
//                memberLbl.textColor = UIColor.init(patternImage: uiimage)
//            }
        }
        
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
