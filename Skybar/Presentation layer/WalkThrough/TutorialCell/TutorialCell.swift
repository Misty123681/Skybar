//
//  TutorialCell.swift
//  Skybar
//
//  Created by Christopher Nassar on 12/8/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class TutorialCell: UICollectionViewCell {

    @IBOutlet weak var letsStartBtn: UIButton!
    @IBOutlet weak var descriptiobLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var parent:WalkThrouController! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    func setInformation(imageName:String,descriptionStr:String,parent:WalkThrouController,startBtn:Bool=true){
        self.parent = parent
        self.descriptiobLbl.text = descriptionStr
        self.imageView.image = UIImage(named: imageName)
        self.letsStartBtn.isHidden = startBtn
        
    }

}
