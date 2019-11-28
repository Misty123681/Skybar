//
//  StarPrivilegesController.swift
//  Skybar
//
//  Created by Christopher Nassar on 9/17/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import WebKit

class StarPrivilegesController: ParentController, WKUIDelegate, WKNavigationDelegate {

    // MARK: - outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var houseRulesView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    var privileges:[Privilege]! = nil
    
    // MARK:- View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "PrivilegesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PrivilegesCell")
        self.houseRulesView.frame = self.view.frame
        self.view.addSubview(self.houseRulesView)
        self.houseRulesView.isHidden = true
        loadLocalHTMLToWebView()
        getPrivileges()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{
            return .default
        }
    }
  
    // MARK:- action & methods
    
    @IBAction func popController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    @objc func navigateToRulesRegulationsPreview(){
        self.houseRulesView.isHidden = false
    }
    
    @IBAction func hideHouseRulesView(_ sender: Any) {
        self.houseRulesView.isHidden = true
    }
   
    // MARK:- Load Html for admission rules
    func loadLocalHTMLToWebView(){
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
                
        if let htmlPath = Bundle.main.path(forResource: "AdmissionRules", ofType: "html"){
            let htmlUrl = URL(fileURLWithPath: htmlPath, isDirectory: false)
            webView.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl)
        }
      
    }
    
   

    // MARK:- Load privileges
    
    func getPrivileges(){
        
        self.view.layoutIfNeeded()
        GlobalUI.showLoading(self.view)
        
        ServiceInterface.getPrivileges(handler: { (success, result) in
            GlobalUI.hideLoading()
            guard let tempData  = result as? Data else{return}
            if success {
                self.privileges = try? JSONDecoder().decode(Privileges.self, from: tempData)
                OperationQueue.main.addOperation {
                    self.tableView.reloadData()
                }
            }else{
                if let res = result as? String{
                    GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                }
            }
        })
    }
    
}

// MARK:- Table view delegate

extension StarPrivilegesController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivilegesCell", for: indexPath) as! PrivilegesCell
        cell.setContent(privileges[indexPath.row],indexPath.row)
        cell.houseRules.addTarget(self, action: #selector(self.navigateToRulesRegulationsPreview), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
