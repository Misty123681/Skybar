//
//  GuestView.swift
//  Skybar
//
//  Created by Christopher Nassar on 1/6/19.
//  Copyright © 2019 Christopher Nassar. All rights reserved.
//

import UIKit

class GuestView: UIView {
    // MARK:- outlets and properties
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var statusLbl: UILabel!
    var parent:GuestListController!
    var guest:GuestElement!
    var guestCount:Int!
    var eventId:String!
    var layerCorners:UIView! = nil

    @IBAction func removeAction(_ sender: Any) {
        GlobalUI.showLoading(parent.view)
        ServiceInterface.removeGuest(guestID: self.guest.id) { (success, result) in
            GlobalUI.hideLoading()
            if success{
                OperationQueue.main.addOperation({
                    self.parent.populateGuests()
                })
            }else{
                
            }
        }
    }
    
    func displayError(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        parent.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        if (nameTF.text?.isEmpty)!{
            displayError(title: "Missing information", message: "Please fill all required information")
            return
        }
        
        if (nameTF.text?.isEmptyField)! {
              displayError(title: "Missing information", message: "This field cannot be left blank")
            return
        }
        
        if guestCount > 7{
            displayError(title: "Error", message: "Reached maximum number of guests for this event")
            return
        }
        
        if let eventId =  eventId{
            GlobalUI.showLoading(parent.view)
            ServiceInterface.addGuest(fullName: nameTF.text!, eventID: eventId){ (success, result) in
                GlobalUI.hideLoading()
                if success{
                    OperationQueue.main.addOperation({
                        self.parent.populateGuests()
                    })
                }else{
                    
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = layerCorners{
            
        }else if !innerView.isHidden{
            self.layoutIfNeeded()
            layerCorners = UIView(frame: self.bounds)
            layerCorners.layer.cornerRadius = 13
            layerCorners.backgroundColor = UIColor.white
            layerCorners.layer.shadowOffset = CGSize.zero
            layerCorners.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.11).cgColor
            layerCorners.layer.shadowOpacity = 1
            layerCorners.layer.shadowRadius = 10
            self.addSubview(layerCorners)
            self.sendSubviewToBack(layerCorners)
            
            innerView.layer.masksToBounds = true
            innerView.layer.cornerRadius = 13
        }
    }
    
    func setInfo(guest:GuestElement, guestCount:Int, eventId:String,parent:GuestListController){
        self.parent = parent
        self.guest = guest
        self.guestCount = guestCount
        self.eventId = eventId
        
        nameLbl.text = guest.guestFullName
        nameTF.text = guest.guestFullName
        if let enteredDate = guest.enteredDate{
            statusLbl.textColor = UIColor.init(red: 0.13, green: 0.64, blue: 0, alpha: 1)
            statusLbl.text = "Entered at \(enteredDate)"
        }
        
        if guest.statusName == "Not In Venue Yet"{
            
            if let createDate = guest.creatededDate{
                if let date = Date(jsonDate: createDate){
                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date / server String
                    formatter.dateFormat = "MMM dd, yyyy - hh:mm a"
                    
                    let monthDayStr = formatter.string(from: date) // string purpose I add here
                    statusLbl.text = monthDayStr.uppercased()
                }
            }
        }
        else if guest.statusName == "In Venue"{
            
            if let enterDate = guest.enteredDate{
                if let date = Date(jsonDate: enterDate){
                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date / server String
                    formatter.dateFormat = "MMM dd, yyyy - hh:mm a"
                    
                    let monthDayStr = formatter.string(from: date) // string purpose I add here
                    statusLbl.text = monthDayStr.uppercased()
                }
            }
            
            statusLbl.backgroundColor = UIColor.gray
        }
  
    }
    
}
