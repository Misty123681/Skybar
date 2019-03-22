//
//  FullscreenController.swift
//  Skybar
//
//  Created by Christopher Nassar on 10/20/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class FullscreenController: UIViewController {

    var url:String! = nil
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url{
            imageView.imageFromServerURL(urlString: url)
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func popScreen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
