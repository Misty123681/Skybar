//
//  TutorialCell.swift
//  Skybar
//
//  Created by Christopher Nassar on 12/8/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class TutorialCell: UICollectionViewCell {
    
     // MARK:- Outlets
    @IBOutlet weak var letsStartBtnConstraint: NSLayoutConstraint!
    @IBOutlet weak var ConstraintHtImage: NSLayoutConstraint!
    @IBOutlet weak var letsStartBtn: UIButton!
    @IBOutlet weak var descriptiobLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var parent:WalkThrouController! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // dynamic size for carousel
        var newMultiplier:CGFloat = 0.7
            let result = UIScreen.main.bounds.size
            if(result.height <= 667.0){  // iphone 5 size
                newMultiplier  = 0.6
                descriptiobLbl.font = descriptiobLbl.font.withSize(17)
            }else{
                 newMultiplier = 0.7  //  > iphone 5 size
                descriptiobLbl.font = descriptiobLbl.font.withSize(20)
            }
           ConstraintHtImage = ConstraintHtImage.setMultiplier(multiplier: newMultiplier)
        }
    
    
    @IBAction func letsStartAction(_ sender: Any) {
        if let parent = parent{
            if let _ = parent.navigationController{
                parent.performSegue(withIdentifier: "toHome", sender: nil)
            }else{
                parent.dismiss(animated: true, completion: nil)
            }
        }
    }
    
      // MARK:- set tutorials info
    func setInformation(imageName:String,descriptionStr:String,parent:WalkThrouController,startBtn:Bool=true){
        self.parent = parent
        self.descriptiobLbl.text = descriptionStr
        self.imageView.image = UIImage(named: imageName)
        self.letsStartBtn.isHidden = startBtn
        if startBtn == false{
           letsStartBtnConstraint.constant = 40
        }else{
            letsStartBtnConstraint.constant = 0
        }
 
    }

}
