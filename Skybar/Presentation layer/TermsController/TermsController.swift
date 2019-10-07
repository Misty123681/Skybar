//
//  TermsController.swift
//  Skybar
//
//  Created by Christopher Nassar on 12/6/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import WebKit

class TermsController: ParentController,WKNavigationDelegate {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var webviewHt: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.scrollView.isScrollEnabled =  false
        if let url = URL(string:"http://skybarstar.com/privacy.html"){
            webView.load(URLRequest(url:url))
            webView.navigationDelegate = self
        }
          self.webviewHt.constant = self.view.frame.size.height
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    @IBAction func backAction(_ sender: Any) {
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        self.loader.startAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        self.loader.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
      
        self.loader.stopAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
             self.headingLbl.text = "PRIVILEGES APPLY UPON YOUR PHYSICAL PRESENCE WITH YOUR STAR CARD ONLY"
            self.webviewHt.constant = webView.scrollView.contentSize.height
        }
        

       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
