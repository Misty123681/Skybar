//
//  StarPrivilegesController.swift
//  Skybar
//
//  Created by Christopher Nassar on 9/17/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import WebKit

class StarPrivilegesController: ParentController,UITableViewDataSource,UITableViewDelegate, WKUIDelegate, WKNavigationDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var houseRulesView: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    var privileges:[Privilege]! = nil
    
    @IBAction func popController(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = privileges{
            return privileges.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrivilegesCell", for: indexPath) as! PrivilegesCell
        cell.setContent(privileges[indexPath.row],indexPath.row)
        
        cell.houseRules.addTarget(self, action: #selector(self.navigateToRulesRegulationsPreview), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func navigateToRulesRegulationsPreview(){
        self.houseRulesView.isHidden = false
    }
    
    @IBAction func hideHouseRulesView(_ sender: Any) {
        self.houseRulesView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "PrivilegesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PrivilegesCell")
        // Do any additional setup after loading the view.
        
        self.houseRulesView.frame = self.view.frame
        self.view.addSubview(self.houseRulesView)
        
        self.houseRulesView.isHidden = true
        
        loadLocalHTMLToWebView()
        
        getPrivileges()
    }
    
    func loadLocalHTMLToWebView(){
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
                
        if let htmlPath = Bundle.main.path(forResource: "AdmissionRules", ofType: "html"){
            let htmlUrl = URL(fileURLWithPath: htmlPath, isDirectory: false)
            webView.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl)
        }
      
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{
            return .default
        }
    }

    func getPrivileges(){
        self.view.layoutIfNeeded()
        GlobalUI.showLoading(self.view)
        
        ServiceInterface.getPrivileges(handler: { (success, result) in
            GlobalUI.hideLoading()
            guard let tempData  = result as? Data else{
                return
            }
        
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
