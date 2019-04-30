
//
//  EventControllerStep1.swift
//  Skybar
//
//  Created by Christopher Nassar on 2/23/19.
//  Copyright © 2019 Christopher Nassar. All rights reserved.
//

import UIKit

class EventControllerStep1: ParentController {
    @IBOutlet weak var doorOpenLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var reservationStatusLabel: UILabel!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var discountLb: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var budgetLbl: UILabel!
    @IBOutlet weak var zoneImageView: UIImageView!
    
    var event:Event! = nil
    var reservation:Reservation! = nil
    var guestCount = 0
    var reservationType = 1
    let step: Float = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfo()
        getZone()
    }
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    @IBAction func budgetChange(_ slider: UISlider) {
        let roundedValue = round(slider.value / step) * step
        slider.value = roundedValue
        
        let discountValue = slider.value*0.75
        discountLb.text = "25% DISCOUNT (\(discountValue.toCurrencyNoPrefix()))"
        budgetLbl.text = slider.value.toCurrencyNoPrefix()
        getZone()
    }
    
    func setInfo(){
        
        budgetLbl.text = slider.value.toCurrencyNoPrefix()
        
        if reservationType == 1{
            reservationStatusLabel.text = "BAR BOOKING \(guestCount) GUESTS"
        }else{
            reservationStatusLabel.text = "TABLE BOOKING \(guestCount) GUESTS"
        }
        
        let discountValue = slider.value*0.75
        discountLb.text = "25% DISCOUNT (\(discountValue.toCurrencyNoPrefix()))"
        
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
    
    func getZone(){
        loader.startAnimating()
        var serviceUrl:String
        serviceUrl = "https://skybarstar.com/UserAppService/GetAvailableZonesImage?budget=\(slider.value)&numberOfGuests=\(guestCount)"
        
        zoneImageView.imageFromServerURL(urlString: serviceUrl, setImage: true) { (success, data) in
            OperationQueue.main.addOperation({
                self.loader.stopAnimating()
            })
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toStep2"){
            let cntrl = segue.destination as! EventControllerStep2
            cntrl.event = event
            cntrl.reservation = reservation
            cntrl.guestCount = guestCount
            cntrl.reservationType = reservationType
            cntrl.budget = slider.value
        }
    }
}
