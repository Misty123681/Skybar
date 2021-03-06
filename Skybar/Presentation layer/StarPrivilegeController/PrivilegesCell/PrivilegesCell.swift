//
//  PrivilegesCell.swift
//  Skybar
//
//  Created by Christopher Nassar on 9/17/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit


class PrivilegesCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var btmDescription: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var privilegeImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var topDescription: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var houseRules: UIButton!
    @IBOutlet weak var houseRulesButtonHeightConstraint: NSLayoutConstraint!
    
    var layerOverlay:UIView! = nil
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = layerOverlay{}else{
            self.innerView.layoutIfNeeded()
            layerOverlay = UIView(frame: self.innerView.bounds)
            layerOverlay.layer.cornerRadius = 13
            layerOverlay.backgroundColor = whiteClr
            layerOverlay.layer.shadowOffset = CGSize.zero
            layerOverlay.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.23).cgColor
            layerOverlay.layer.shadowOpacity = 1
            layerOverlay.layer.shadowRadius = 8
            self.innerView.addSubview(layerOverlay)
            self.innerView.sendSubviewToBack(layerOverlay)
        }
    }
    
     // MARK: - set content
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
        
        if(index == 0){
            
            let dear = "Dear "
            let name = "\(String(describing: ServiceUser.profile?.level ?? ""))".firstCharacterUpperCase() ?? ""
        
            let between = ",\n\nMany benefits await you as we strive to make your nights memorable."
            let final = "\n\nThank you,"
            let priveleges = "\n\nPRIVILEGES APPLY UPON YOUR PHYSICAL PRESENCE WITH YOUR STAR CARD ONLY"
            
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
                                                        attributes: [NSAttributedString.Key.font: UIFont.init(name: "SourceSansPro-bold",size:13),NSAttributedString.Key.foregroundColor:UIColor.init(displayP3Red: 1.0, green:0, blue: 0, alpha: 1.0)]));


            topDescription.attributedText = attrString
            houseRules.isHidden = false
            houseRulesButtonHeightConstraint.constant = 50.0
            
        }else{
            topDescription.text = nil
            houseRules.isHidden = true
            houseRulesButtonHeightConstraint.constant = 10.0
        }
    }
    
}
