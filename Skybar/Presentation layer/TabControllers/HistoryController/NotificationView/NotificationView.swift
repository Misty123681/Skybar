//
//  NotificationView.swift
//  Skybar
//
//  Created by Christopher Nassar on 10/30/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class NotificationView: UIView {
    
    //MARK:- outlets
    @IBOutlet weak var valueLbl: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    
    var layerCorners:UIView! = nil
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = layerCorners{}else{
            self.layoutIfNeeded()
            layerCorners = UIView(frame: self.innerView.frame)
            layerCorners.layer.cornerRadius = 13
            layerCorners.backgroundColor = whiteClr
            layerCorners.layer.shadowOffset = CGSize.zero
            layerCorners.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.11).cgColor
            layerCorners.layer.shadowOpacity = 1
            layerCorners.layer.shadowRadius = 10
            self.addSubview(layerCorners)
            self.sendSubviewToBack(layerCorners)
            
            innerView.layer.masksToBounds = true
            innerView.layer.cornerRadius = 13
        }
    }
    
    func setInfo(notification:Notification){
        if let content = notification.content{
            valueLbl.text = content
        }
        
        if let dateStr = notification.dateCreated{
            if let date = Date(jsonDate: dateStr){
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "MMM dd, yyyy - hh:mm a"
                
                let str = formatter.string(from: date) // string purpose I add here
                dateLbl.text = str.uppercased()
            }
        }
    }

}
