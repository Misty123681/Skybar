//
//  PrivilegesCell.swift
//  Skybar
//
//  Created by Christopher Nassar on 9/17/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class PrivilegesCell: UITableViewCell {

    @IBOutlet weak var btmDescription: UILabel!
    var layerOverlay:UIView! = nil
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var privilegeImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var topDescription: UILabel!
    @IBOutlet weak var innerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = layerOverlay{}else{
            self.innerView.layoutIfNeeded()
            layerOverlay = UIView(frame: self.innerView.bounds)
            layerOverlay.layer.cornerRadius = 13
            layerOverlay.backgroundColor = UIColor.white
            layerOverlay.layer.shadowOffset = CGSize.zero
            layerOverlay.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.23).cgColor
            layerOverlay.layer.shadowOpacity = 1
            layerOverlay.layer.shadowRadius = 8
            self.innerView.addSubview(layerOverlay)
            self.innerView.sendSubviewToBack(layerOverlay)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setContent(_ data:Privilege,_ index:Int){
        titleLbl.text = data.title
        
        if let imageKey = data.benefitImageName{
            loader.startAnimating()
            ServiceInterface.getImage(imageName: imageKey) { (success, result) in
                OperationQueue.main.addOperation {
                    self.loader.stopAnimating()
                    if success {
                        if let data = result as? Data{
                            self.privilegeImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
        
        btmDescription.text = data.description;
        
        //Dear XXX YYY,
        
//        We value you as a STAR, please find below your privileges in our venue.
//        We strive to make your experience at SKY2.0 memorable…
//
//        Cheers to you!
        if(index == 0){
            
            let dear = "Dear "
            let name = (ServiceUser.profile?.firstName)!
            let between = ",\n\nMany benefits await you as we strive to make your nights memorable…"
            let final = "\n\nCheers to you!"
            let priveleges = "\n\nPRIVILEGES APPLY UPON YOUR PHYSICAL PRESENCE ONLY"
            
            let attrString = NSMutableAttributedString(string: dear,
                                                       attributes: [NSAttributedString.Key.font:
                                                        UIFont.init(name: "SourceSansPro-Regular", size: 16)!]);
            
            attrString.append(NSMutableAttributedString(string: name,
                                                        attributes: [NSAttributedString.Key.font:
                                                        UIFont.init(name: "SourceSansPro-Bold", size: 16)!]))
            
            attrString.append(NSMutableAttributedString(string: between,
                                                        attributes: [NSAttributedString.Key.font: UIFont.init(name: "SourceSansPro-Regular", size: 16)!]))
            
            attrString.append(NSMutableAttributedString(string: final,
                                                        attributes: [NSAttributedString.Key.font: UIFont.init(name: "SourceSansPro-Regular", size: 16)!]));
            attrString.append(NSMutableAttributedString(string: priveleges,
                                                        attributes: [NSAttributedString.Key.font: UIFont.init(name: "SourceSansPro-bold",size:13),NSAttributedString.Key.foregroundColor:UIColor.init(displayP3Red: 0.43, green:0.60, blue: 0.35, alpha: 1.0)]));


            topDescription.attributedText = attrString
        }else{
            topDescription.text = nil
        }
    }
    
}
