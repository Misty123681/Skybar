//
//  StarPrivilegesController.swift
//  Skybar
//
//  Created by Christopher Nassar on 9/17/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class StarPrivilegesController: ParentController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var privileges:[Privilege]! = nil
    
    @IBAction func popController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        let nib = UINib(nibName: "PrivilegesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PrivilegesCell")
        // Do any additional setup after loading the view.
        
        getPrivileges()
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
            if success {
                self.privileges = try? JSONDecoder().decode(Privileges.self, from: result as! Data)
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
