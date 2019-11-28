//
//  ReserveEventController.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/5/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class ReserveEventController: ParentController {
    
    // MARK:- Outlets
    @IBOutlet weak var maxLbl: UILabel!
    @IBOutlet weak var barBtn: UIButton!
    @IBOutlet weak var tableBtn: UIButton!
    @IBOutlet weak var reservationPopupView: UIView!
    @IBOutlet weak var reservationNumberLbl: UILabel!
    @IBOutlet weak var reservationDateLbl: UILabel!
    @IBOutlet weak var reservationNameLbl: UILabel!
    @IBOutlet weak var guestNumberLbl: UILabel!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    
    // MARK:- variables
    var guestCount = 0
    var event:Event! = nil
    var reservationType = 1
    var reservationRules:ReservationRules! = nil
    var minimumLimit = 0
    var maximumLimit = 15
    
    // MARK:- view cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.guestNumberLbl.text = "\(guestCount)"
        enablePlusButton()
        disableMinusButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        barBtn.tag = 11
        setGradientBgToButton(btn: barBtn)
        tableBtn.tag = 0
        setGradientBgToButton(btn: tableBtn)
        plusBtn.titleEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        minusBtn.titleEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        GlobalUI.showLoading(self.view)
        getReservationRules()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    
   //MARK:- action & methods

    @IBAction func callToReserve(_ sender: Any) {
        if let url = URL(string: "tel://\(ServiceUser.contactPhoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func hidePopup(_ sender: Any) {
        reservationPopupView.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /// increse the no of guest by 2
    ///
    /// - Parameter sender: input button
    @IBAction func plusAction(_ sender: Any) {
        guestCount += 2
        self.guestNumberLbl.text = "\(guestCount)"
        if(guestCount>1){
            enableMinusButton()
        }

        if(guestCount >= self.maximumLimit){ // guestcnt >= maxlimit then its tbl else bar
            if(reservationType == 1){
                tableAction(self.view)
                maxLbl.text = "The reservation has become a table booking"
            }else{
                disablePlusButton()
            }
        }
    }
    
    /// decrease the the no of guest by 2
    ///
    /// - Parameter sender: input button
    @IBAction func minusAction(_ sender: Any) {
        guestCount -= 2
        enablePlusButton()
        self.guestNumberLbl.text = "\(guestCount)"
        if(guestCount == self.minimumLimit){
            disableMinusButton()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func enableMinusButton(){
        self.minusBtn.layer.borderWidth = 1
        self.minusBtn.layer.borderColor = blueColorTheme.cgColor
        self.minusBtn.setTitleColor(blueColorTheme, for: .normal)
        minusBtn.isEnabled = true
    }
    
    func enablePlusButton(){
        self.plusBtn.layer.borderWidth = 1
        self.plusBtn.layer.borderColor = blueColorTheme.cgColor
        self.plusBtn.setTitleColor(blueColorTheme, for: .normal)
        plusBtn.isEnabled = true
    }
    
    func disableMinusButton(){
        self.minusBtn.layer.borderWidth = 1
        self.minusBtn.layer.borderColor = grayColor.cgColor
        self.minusBtn.setTitleColor(grayColor, for: .normal)
        minusBtn.isEnabled = false
    }
    
    func disablePlusButton(){
        self.plusBtn.layer.borderWidth = 1
        self.plusBtn.layer.borderColor = grayColor.cgColor
        self.plusBtn.setTitleColor(grayColor, for: .normal)
        plusBtn.isEnabled = false
    }
    
    // MARK:- get reservation rules
    fileprivate func getReservationRules() {
        ServiceInterface.getReservationRules(handler: { (success, result) in
            GlobalUI.hideLoading()
            if success {
                do{
                    let rules = try JSONDecoder().decode(ReservationRules.self, from: result as! Data)
                    self.reservationRules = rules
                    self.minimumLimit = rules.barMinimumNumberOfPeople
                    self.maximumLimit = rules.barMaximumNumberOfPeople
                    self.guestCount = self.minimumLimit
                    OperationQueue.main.addOperation({
                        self.guestNumberLbl.text = "\(self.guestCount)"
                        self.maxLbl.text = "You can reserve up to \(self.maximumLimit) people"
                    })
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
    
    

    
    
    // MARK:- Booking reservation call
    @IBAction func confirmReservation(_ sender: Any) {
        reserveEvent()
    }
    
    // MARK:- Table tapped
    @IBAction func tableAction(_ sender: Any) {
        self.minimumLimit = self.reservationRules.tableMinimumNumberOfPeople
        self.maximumLimit = self.reservationRules.tableMaximumNumberOfPeople
        self.maxLbl.text = "You can reserve up to \(self.maximumLimit) people"
        reservationType = 2
        barBtn.tag = 0
        setGradientBgToButton(btn: barBtn)
        tableBtn.tag = 11
        setGradientBgToButton(btn: tableBtn)
        
        guestCount = self.minimumLimit
        self.guestNumberLbl.text = "\(self.guestCount)"
        disableMinusButton()
        enablePlusButton()
        
        maxLbl.text = "All reservations at the bar above \(self.reservationRules.barMaximumNumberOfPeople) people are switched to table bookings"
    }
    
    
    // MARK:- Bar tapped
    @IBAction func barAction(_ sender: Any) {
        self.minimumLimit = self.reservationRules.barMinimumNumberOfPeople
        self.maximumLimit = self.reservationRules.barMaximumNumberOfPeople
        self.maxLbl.text = "You can reserve up to \(self.maximumLimit) people"
        reservationType = 1
        barBtn.tag = 11
        setGradientBgToButton(btn: barBtn)
        
        tableBtn.tag = 0
        setGradientBgToButton(btn: tableBtn)
        
        guestCount = self.minimumLimit
        self.guestNumberLbl.text = "\(self.guestCount)"
        disableMinusButton()
        enablePlusButton()
        
        maxLbl.text = "Every bar stool fits 2 people"
    }
    
    //MARK:- action & methods
    
    func setGradientBgToButton(btn: UIButton){
        if(btn.tag == 11){
           btn.setGradient()
        }else{
            btn.setTitleColor(titleBlueClr, for: .normal)
            if let view = btn.viewWithTag(10){
                view.removeFromSuperview()
            }
        }
    }
    
    // MARK:- popup UI
    func showReservationPopup(){
        var typStr = "Table"
        if reservationType == 1{
            typStr = "Bar"
        }
        
        self.reservationNumberLbl.text = "\(typStr) Reservation for \(guestNumberLbl.text!)"
        
        if let eventDate = event.eventDate{
            if let date = Date(jsonDate: eventDate){
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "EEE - MMM dd yyyy"
                
                let monthDayStr = formatter.string(from: date) // string purpose I add here
                self.reservationDateLbl.text = monthDayStr.uppercased()
            }
        }
 
        self.reservationNameLbl.text = event.name
        self.reservationPopupView.isHidden = false
    }
    
      // MARK:-  APi Booking resrvation
    
    func reserveEvent(){
        GlobalUI.showLoading(self.view)
        let guests = Int(guestNumberLbl.text!)!
        ServiceInterface.reserveEvent(eventID: event.id!, type: reservationType, guests:guests, budget: 0 , handler: { (success, result) in
            GlobalUI.hideLoading()
            if let data = result as? Data{
                    if let resultStr = String(data: data, encoding: String.Encoding.utf8){
                        if(!resultStr.isEmpty){
                        OperationQueue.main.addOperation({
                            self.showReservationPopup()
                        })
                    }else{
                        GlobalUI.showMessage(title: "Error", message: "Reservation did not go through", cntrl: self)
                    }
                }
            }
        })
        
    }
    
}
