//
//  GuestView.swift
//  Skybar
//
//  Created by Christopher Nassar on 1/6/19.
//  Copyright © 2019 Christopher Nassar. All rights reserved.
//

import UIKit

class GuestView: UIView {
    @IBOutlet weak var nameLbl: UILabel!
    var layerCorners:UIView! = nil
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var statusLbl: UILabel!
    var parent:GuestListController!
    var guest:GuestElement!
    var eventId:String!
    
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
    
    func displayError(){
        let alert = UIAlertController(title: "Missing information", message: "Please fill all required information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        parent.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addAction(_ sender: Any) {
        
        if (nameTF.text?.isEmpty)!{
            displayError()
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
    
    func setInfo(guest:GuestElement,eventId:String,parent:GuestListController){
        self.parent = parent
        self.guest = guest
        self.eventId = eventId
        nameLbl.text = guest.guestFullName
        nameTF.text = guest.guestFullName
        statusLbl.text = "Added To Guest List"
        
        if let enteredDate = guest.enteredDate{
            statusLbl.textColor = UIColor.init(red: 0.13, green: 0.64, blue: 0, alpha: 1)
            statusLbl.text = "Entered at \(enteredDate)"
        }
        
        if let statusName = guest.statusName{
            statusLbl.text = statusName
        }
    }
    
}
