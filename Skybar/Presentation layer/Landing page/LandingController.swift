//
//  ViewController.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/20/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class LandingController: ParentController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        if ServiceUser.loggedIn(){
//            self.performSegue(withIdentifier: "toHome", sender: nil)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

