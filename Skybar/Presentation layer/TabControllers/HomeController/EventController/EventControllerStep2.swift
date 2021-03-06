//
//  EventControllerStep2.swift
//  Skybar
//
//  Created by Christopher Nassar on 2/23/19.
//  Copyright © 2019 Christopher Nassar. All rights reserved.
//

import UIKit

class EventControllerStep2: ParentController {
    
    //MARK:- Outlets
    
    @IBOutlet weak var constraintWidthZoneImage: NSLayoutConstraint!
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
    
    //MARK:- Variables
    var event:Event! = nil
    var reservation:Reservation! = nil
    var guestCount = 0
    var reservationType = 1
    var budget:Float = 0
    
     //MARK:- View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReservationPopUp()
        setInfo()
        getZone()
        getZoneImage()
        setZoneImageSize()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
     //MARK:- Methods and action
    fileprivate func setZoneImageSize() {
        let newMultiplier:CGFloat = 0.75
        constraintWidthZoneImage = constraintWidthZoneImage.setMultiplier(multiplier: newMultiplier)
        self.loadViewIfNeeded()
    }
    fileprivate func addReservationPopUp() {
        let screen = UIScreen.main.bounds.size
        reservationPopupView.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        self.view.addSubview(reservationPopupView)
    }
    // MARK:- get Zone image
    func getZoneImage(){
        loader.startAnimating()
        var serviceUrl:String
        serviceUrl = "https://skybarstar.com/UserAppService/GetAvailableZonesImage?budget=\(budget)&numberOfGuests=\(guestCount)"
        
        zoneImageView.imageFromServerURL(urlString: serviceUrl, setImage: true) { (success, data) in
            OperationQueue.main.addOperation({
                self.loader.stopAnimating()
            })
        }
    }
    // MARK:- get Zone by budget
    func getZone(){
        ServiceInterface.getZonesByBudget(budget: budget, numberOfGuests: guestCount) { (success, result) in
            if success {
                do{
                    let zones = try JSONDecoder().decode(Zones.self, from: result as! Data)
                    OperationQueue.main.addOperation({
                        self.zonesLabel.text = "ZONES: "
                        for (index,zone) in zones.enumerated(){
                            if let name = zone.zoneName{
                                self.zonesLabel.text! += name
                                if index<zones.count-1{
                                    self.zonesLabel.text! += ", "
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
    
    // MARK:-  set info
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
    // MARK:-  call tapped
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
}
