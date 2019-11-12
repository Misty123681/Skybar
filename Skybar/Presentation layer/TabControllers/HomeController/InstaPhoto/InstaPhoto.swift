//
//  InstaPhoto.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/31/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

protocol InstaDelegate {
    func openMedia(media:InstaMedia,index:Int)
    func closeMedia(media:InstaMedia)
    func openFullScreen(media:InstaMedia)
}

class InstaPhoto: UIView {

    //MARK:- Outlet
    
    @IBOutlet weak var playIcon: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    
    var parent:InstaDelegate!
    var media:InstaMedia!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(openMedia))
        self.addGestureRecognizer(tap)
    }
    
    @objc func openMedia(){
        if let parent = parent {
            parent.openMedia(media: media,index:self.tag)
        }
    }
    
    func setInfo(_ media:InstaMedia,parent:InstaDelegate){
        self.media = media
        self.parent = parent
        self.loader.startAnimating()
        if let imageMedia = media.images{
            imageView.imageFromServerURL(urlString: imageMedia.thumbnail.url) { (success,data) in
                OperationQueue.main.addOperation({
                    self.loader.stopAnimating()
                })
            }
        }
        
        if let _ = self.media.videos{
            playIcon.isHidden = false
        }else{
            playIcon.isHidden = true
        }
    }
}
