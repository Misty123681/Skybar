//
//  FullscreenController.swift
//  Skybar
//
//  Created by Christopher Nassar on 10/20/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class FullscreenController: UIViewController {
    
    //MARK:- Outlet
    var url:String! = nil
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK:- view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url{
            imageView.imageFromServerURL(urlString: url)
        }
    }

    @IBAction func popScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
  


}
