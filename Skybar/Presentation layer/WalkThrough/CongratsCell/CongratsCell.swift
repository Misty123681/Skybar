//
//  CongratsCell.swift
//  Skybar
//
//  Created by Christopher Nassar on 12/8/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class CongratsCell: UICollectionViewCell {
    
    // MARK:- Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lNameLbl: UILabel!
    @IBOutlet weak var fNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setInformation(profileID:String,fName:String,lName:String){
        
        fNameLbl.text = fName
        lNameLbl.text = lName
        self.layoutIfNeeded()
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius =  self.imageView.getHeight()/2
        
        ServiceInterface.getImage(imageName: "\(profileID).jpg", handler: { (success, result) in
            if success {
                if let data = result as? Data{
                    OperationQueue.main.addOperation {
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        })
    }

}
