//
//  ReserveEventController.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/5/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class ReserveEventController: ParentController {

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
    var guestCount = 0
    var event:Event! = nil
    var reservationType = 1
    var reservationRules:ReservationRules! = nil
    
    var minimumLimit = 0
    var maximumLimit = 15
    
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
    
    @IBAction func plusAction(_ sender: Any) {
        guestCount += 2
        self.guestNumberLbl.text = "\(guestCount)"
        if(guestCount>1){
            enableMinusButton()
        }

        if(guestCount >= self.maximumLimit){
            if(reservationType == 1){
                tableAction(self.view)
                maxLbl.text = "The reservation has become a table booking"
            }else{
                disablePlusButton()
            }
        }
    }
    
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
        self.minusBtn.layer.borderColor = UIColor(red:0.08, green:0.34, blue:0.8, alpha:1).cgColor
        self.minusBtn.setTitleColor(UIColor(red:0.08, green:0.34, blue:0.8, alpha:1), for: .normal)
        minusBtn.isEnabled = true
    }
    
    func enablePlusButton(){
        self.plusBtn.layer.borderWidth = 1
        self.plusBtn.layer.borderColor = UIColor(red:0.08, green:0.34, blue:0.8, alpha:1).cgColor
        self.plusBtn.setTitleColor(UIColor(red:0.08, green:0.34, blue:0.8, alpha:1), for: .normal)
        plusBtn.isEnabled = true
    }
    
    func disableMinusButton(){
        self.minusBtn.layer.borderWidth = 1
        self.minusBtn.layer.borderColor = UIColor.gray.cgColor
        self.minusBtn.setTitleColor(UIColor.gray, for: .normal)
        minusBtn.isEnabled = false
    }
    
    func disablePlusButton(){
        self.plusBtn.layer.borderWidth = 1
        self.plusBtn.layer.borderColor = UIColor.gray.cgColor
        self.plusBtn.setTitleColor(UIColor.gray, for: .normal)
        plusBtn.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.guestNumberLbl.text = "\(guestCount)"
        enablePlusButton()
        disableMinusButton()
        
        barBtn.tag = 11
        setGradientBgToButton(btn: barBtn)
        
        tableBtn.tag = 0
        setGradientBgToButton(btn: tableBtn)
        
        // Do any additional setup after loading the view.
        plusBtn.titleEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        minusBtn.titleEdgeInsets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        
        GlobalUI.showLoading(self.view)
        
        
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

    @IBAction func confirmReservation(_ sender: Any) {
        reserveEvent()
    }
    
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
    
    func setGradientBgToButton(btn: UIButton){
        
        if(btn.tag == 11){
            btn.setTitleColor(.white, for: .normal)
            let overlayer = UIView(frame: btn.bounds)
            overlayer.tag = 10
            overlayer.layer.cornerRadius = btn.frame.size.height/2
            
            let gradient = CAGradientLayer()
            gradient.frame = btn.bounds
            gradient.colors = [
                UIColor(red:0, green:0.64, blue:0.95, alpha:1).cgColor,
                UIColor(red:0.04, green:0.22, blue:0.61, alpha:1).cgColor
            ]
            gradient.locations = [0, 1]
            gradient.startPoint = CGPoint(x: 1, y: 0.2)
            gradient.endPoint = CGPoint(x: 0.3, y: 0.67)
            gradient.cornerRadius = btn.frame.size.height/2
            
            overlayer.layer.addSublayer(gradient)
            
            btn.addSubview(overlayer)
            btn.sendSubviewToBack(overlayer)
        }else{
            btn.setTitleColor(UIColor.init(red: 0, green: 164.0/255.0, blue: 242.0/255.0, alpha: 1), for: .normal)
            
            if let view = btn.viewWithTag(10){
                
                view.removeFromSuperview()
            }
        }
    }
    
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
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
