//
//  EditInfoController.swift
//  Skybar
//
//  Created by Christopher Nassar on 7/24/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit
import MapKit
import IQKeyboardManagerSwift
import ActionSheetPicker_3_0

class EditInfoController: ParentController{
    
    // MARK: - IBOutlets
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    // MARK: - variables
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var coordinate:CLLocationCoordinate2D! = nil
    var startSearch = false
    var phoneCodes:[PhoneCode]!
    
    
    // MARK: - view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.text = ServiceUser.profile?.email
        emailTF.placeholder = ServiceUser.profile?.email
        countryCodeTF.text = ServiceUser.profile?.phoneCode
        countryCodeTF.placeholder = ServiceUser.profile?.phoneCode
        
        if let mobileNumber = ServiceUser.profile?.mobile{
            phoneTF.text = mobileNumber
            phoneTF.placeholder = mobileNumber
        }
        addressTF.text = ServiceUser.profile?.address
        addressTF.placeholder = ServiceUser.profile?.address
        searchTableView.tableFooterView = UIView()
        searchCompleter.delegate = self
        
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 100
        getCountryCodes()
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        GlobalUI.showLoading(self.view)
        
        if let profile = ServiceUser.profile{
            profile.address = addressTF.text!
            profile.email = emailTF.text!
            profile.phoneCode = countryCodeTF.text!
            profile.mobile = phoneTF.text!
            
            if let coordinate = coordinate{
                ServiceInterface.setAddressLocation(longitude: coordinate.longitude, latitude: coordinate.latitude) { (success, result) in
                }
            }
            
            //MARK:- update info
            ServiceInterface.updateUserInfo(profile: profile,handler: { (success, result) in
                GlobalUI.hideLoading()
                if success {
                    OperationQueue.main.addOperation({
                       self.backAction(self.view)
                    })
                }else{
                    if let res = result as? String{
                        GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                    }
                }
            })
        }
    }
    
    @IBAction func endAddressAction(_ sender: Any) {
        searchTableView.isHidden = true
        startSearch = false
    }
    
    @IBAction func addressChange(_ sender: Any) {
        guard let text = addressTF.text else{
            return
        }
        if text.isEmpty{
            return
        }
        
        startSearch = true
        searchCompleter.queryFragment = text
        
    }
    
    func getCountryCodes(){
        GlobalUI.showLoading(self.view)
        
        ServiceInterface.getCountryCodes( handler: { (success, result) in
            GlobalUI.hideLoading()
            if success {
                
                do{
                    self.phoneCodes = try JSONDecoder().decode(PhoneCodes.self, from: result as! Data)
                }
                catch let error{
                    print(error)
                }
            }else{
                if let res = result as? String{
                    GlobalUI.showMessage(title: "Error", message: res, cntrl: self)
                }
            }
        })
    }
    
    

  
    @IBAction func countryCodeAction(_ sender: Any) {
        
        if let codes = phoneCodes{
            
            let codesStr = codes.compactMap({$0.phoneCode})
            ActionSheetMultipleStringPicker.show(withTitle: "Country Code", rows: [
                codesStr], initialSelection: [0], doneBlock: {
                    picker, indexes, values in
                    if let arr = values as? [String]{
                        self.countryCodeTF.text = "+"+arr.first!
                    }
            }, cancel: { ActionMultipleStringCancelBlock in return }, origin: self.view)
        }
    }
}

 // MARK: - Table view Delegate
extension EditInfoController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchResult = searchResults[indexPath.row]
        addressTF.text = searchResult.title
        addressTF.resignFirstResponder()
        tableView.isHidden = true
        
        let searchRequest = MKLocalSearch.Request(completion: searchResult)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if let response = response{
                if response.mapItems.count > 0{
                    self.coordinate = response.mapItems[0].placemark.coordinate
                    ServiceUser.location = self.coordinate
                }
            }
        }
    }
    
}

 // MARK: -  MKLocalSearchCompleterDelegate
extension EditInfoController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        if !startSearch{
            return
        }
        
        searchResults = completer.results
        
        if searchResults.count > 0{
            if searchTableView.isHidden{
                searchTableView.isHidden = false
            }
            
            searchTableView.reloadData()
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {}
}
