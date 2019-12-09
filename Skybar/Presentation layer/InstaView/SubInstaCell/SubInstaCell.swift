//
//  SubInstaCell.swift
//  Skybar
//
//  Created by Christopher Nassar on 12/6/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import AVKit

class SubInstaCell: UICollectionViewCell {

    // MARK:- Outlets
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var firstLineLbl: UILabel!
    @IBOutlet weak var playIconBtn: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var captionLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullnameLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var contentView1: UIView!
    
    // MARK:- Variable
    var instaObject:InstaMedia!
    var parent:InstaDelegate!
    var player:AVPlayer!
    let playerViewController = AVPlayerViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()}
    
    @IBAction func playAction(_ sender: Any) {
        if let video = instaObject.videos{
            if let videoInfo = video.standardResolution{
                if let url = URL(string:videoInfo.url),let parent = parent as? UIViewController{
                    player = AVPlayer(url: url)
                    playerViewController.player = player
                    parent.present(playerViewController, animated: true) {
                        self.playerViewController.player!.play()
                    }
                }
            }
        }
    }
    
    @IBAction func fullScreen(){
        if let parent = parent {
            parent.openFullScreen(media: instaObject)
        }
    }
    
    func setMedia(_ media:InstaMedia,index:Int,parent:InstaDelegate){
        self.instaObject = media
        self.parent = parent
        self.tag = index
        
        imageView.image = nil
        
        if let _ = media.videos{
            self.playIconBtn.isHidden = false
        }else{
            self.playIconBtn.isHidden = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(fullScreen))
            imageView.addGestureRecognizer(tap)
        }
        
        if let imageMedia = media.images{
            imageView.imageFromServerURL(urlString: imageMedia.standardResolution.url,setImage: false) { (success,data) in
                if success{
                    if let data = data{
                        if index == self.tag{
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
        
        userImageView.imageFromServerURL(urlString: media.user.profilePicture)
        fullnameLbl.text = media.user.fullName
    
        firstLineLbl.text = media.user.username
        usernameLbl.text = media.user.username
        likesLbl.text = "\(media.likes.count) ❤️"
        captionLbl.text = media.caption.text
        
    }

}
