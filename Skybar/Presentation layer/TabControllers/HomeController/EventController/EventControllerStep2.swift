//
//  EventControllerStep2.swift
//  Skybar
//
//  Created by Christopher Nassar on 2/23/19.
//  Copyright © 2019 Christopher Nassar. All rights reserved.
//

import UIKit

class EventControllerStep2: ParentController {
    
    @IBOutlet weak var doorOpenLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var reservationStatusLabel: UILabel!
    @IBOutlet weak var zonesLabel: UILabel!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var discountLb: UILabel!
    @IBOutlet weak var budgetLbl: UILabel!
    @IBOutlet weak var zoneImageView: UIImageView!
    
    @IBOutlet weak var zonesResLbl: UILabel!
    @IBOutlet weak var reservationPopupView: UIView!
    @IBOutlet weak var reservationNumberLbl: UILabel!
    @IBOutlet weak var reservationDateLbl: UILabel!
    @IBOutlet weak var reservationNameLbl: UILabel!
    
    var event:Event! = nil
    var reservation:Reservation! = nil
    var guestCount = 0
    var reservationType = 1
    var budget:Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
        getZone()
        getZoneImage()
    }
    
    func getZoneImage(){
        loader.startAnimating()
        zoneImageView.imageFromServerURL(urlString: "http://skybarstar.com/UserAppService/GetAvailableZonesImage?budget=\(budget)", setImage: true) { (success, data) in
            OperationQueue.main.addOperation({
                self.loader.stopAnimating()
            })
        }
    }
    
    func getZone(){
        ServiceInterface.getZonesByBudget(budget: budget) { (success, result) in
            OperationQueue.main.addOperation({
                
            })
            
            if success {
                do{
                    let zones = try JSONDecoder().decode(Zones.self, from: result as! Data)
                    OperationQueue.main.addOperation({
                        self.zonesLabel.text = "ZONES:"
                        
                        for (index,zone) in zones.enumerated(){
                            if let name = zone.zoneName{
                                self.zonesLabel.text! += name
                                if index<zones.count-1{
                                    self.zonesLabel.text! += ","
                                }
                            }
                        }
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
            
        }
    }
    
    func setInfo(){
        
        if reservationType == 1{
            reservationStatusLabel.text = "BAR BOOKING \(guestCount) GUESTS"
        }else{
            reservationStatusLabel.text = "TABLE BOOKING \(guestCount) GUESTS"
        }
        
        budgetLbl.text = "Booking per person \(budget.toCurrency())"
        
        if let event = event{
            
            titleLbl.text = event.name
            
            descriptionLbl.text = event.description
            
            if let doorOpen = event.doorOpen{
                doorOpenLbl.text = "Doors open at \(doorOpen)"
            }
            
            if let eventDate = event.eventDate{
                if let date = Date(jsonDate: eventDate){
                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date / server String
                    formatter.dateFormat = "MMM dd, yyyy"
                    
                    let monthDayStr = formatter.string(from: date) // string purpose I add here
                    dateLbl.text = monthDayStr.uppercased()
                }
            }
        }
        
        if let reservation = reservation{
            if let name = reservation.eventName{
                titleLbl.text = name
            }
            
            if let desc = reservation.description{
                descriptionLbl.text = desc
            }
            
            if let eventDate = reservation.eventDate{
                if let date = Date(jsonDate: eventDate){
                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date / server String
                    formatter.dateFormat = "MMM dd, yyyy"
                    
                    let monthDayStr = formatter.string(from: date) // string purpose I add here
                    dateLbl.text = monthDayStr.uppercased()
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
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
        if let homeController = self.navigationController?.viewControllers.filter({$0 is HomeController}).first{
            self.navigationController?.popToViewController(homeController, animated: true)
        }
    }
    
    @IBAction func reserveEvent(){
        GlobalUI.showLoading(self.view)
        ServiceInterface.reserveEvent(eventID: event.id!, type: reservationType, guests:guestCount, budget: budget , handler: { (success, result) in
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
    
    func showReservationPopup(){
        
        let typStr = "Table"
        self.reservationNumberLbl.text = "\(typStr) Reservation for \(guestCount)"
        self.zonesResLbl.text = self.zonesLabel.text
        
        if let event = event{
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
        }
        
        if let reservation = reservation{
            if let eventDate = reservation.eventDate{
                if let date = Date(jsonDate: eventDate){
                    let formatter = DateFormatter()
                    // initially set the format based on your datepicker date / server String
                    formatter.dateFormat = "EEE - MMM dd yyyy"
                    
                    let monthDayStr = formatter.string(from: date) // string purpose I add here
                    self.reservationDateLbl.text = monthDayStr.uppercased()
                }
            }
            
            self.reservationNameLbl.text = reservation.eventName
        }
        
        self.reservationPopupView.isHidden = false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}
