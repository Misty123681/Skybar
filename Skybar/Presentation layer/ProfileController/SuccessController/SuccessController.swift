//
//  SuccessController.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/3/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class WhiteButton:UIButton{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if tag == 1{
            if let view = self.viewWithTag(100){
                view.removeFromSuperview()
            }
        }else{
            if let _ = self.viewWithTag(100){
            }else{
                let layer = UIView(frame: self.bounds)
                layer.tag = 100
                layer.isUserInteractionEnabled = false
                layer.layer.cornerRadius = 13
                layer.backgroundColor = UIColor.white
                layer.layer.shadowOffset = CGSize.zero
                layer.layer.shadowColor = UIColor(red:1, green:1, blue:1, alpha:0.73).cgColor
                layer.layer.shadowOpacity = 1
                layer.layer.shadowRadius = 27
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 13
                self.addSubview(layer)
                self.sendSubviewToBack(layer)
            }
        }
    }
}
class SuccessController: ParentController {

    @IBOutlet weak var overlayView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layoutIfNeeded()
        // Do any additional setup after loading the view.
        let layer = UIView(frame: self.view.bounds)
        
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.74)
        layer.layer.addSublayer(gradient)
        
        self.overlayView.addSubview(layer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
