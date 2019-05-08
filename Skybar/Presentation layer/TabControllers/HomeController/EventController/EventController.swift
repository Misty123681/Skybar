//
//  EventController.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/5/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class EventController: ParentController {

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
    
    @IBOutlet weak var doorOpenLbl: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var event:Event! = nil
    var reservation:Reservation! = nil
    
    var guestCount = 0
    var reservationType = 1
    var reservationRules:ReservationRules! = nil
    var minimumLimit = 0
    var maximumLimit = 15
    var editEvent = false
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var modifyBtn: UIButton!
    
    @IBOutlet weak var reserveBtn: UIButton!
    
    @IBAction func cancelACtion(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to Cancel reservation?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.cancelReservation()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func modifyAction(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to Modify reservation?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.editReservation()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func editReservation(){
        var id = ""
        if let _ = event{
            id = event.id!
        }else
        if let _ = reservation{
            id = reservation.id ?? ""
        }
        
        ServiceInterface.editReservation(reservationId: id, type: reservationType, guests: Int(guestNumberLbl.text!)!) { (success, result) in
            if success{
                OperationQueue.main.addOperation({
                    self.showReservationPopup()
                })
            }
        }
    }
    
    func cancelReservation(){
        var id = ""
        if let _ = event{
            id = event.id!
        }else
            if let _ = reservation{
                id = reservation.id ?? ""
        }
        ServiceInterface.cancelReservation(reservationId: id) { (success, result) in
            if success{
                OperationQueue.main.addOperation({
                    self.navigationController?.popViewController(animated: true)
                })
                
                    let alert = UIAlertController(title: "Your booking was successfully deleted", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                  //self.reservationPopupView.isHidden=true
                    self.reservationPopupView.isHidden = true
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)               }
        }
    }
    
    
    
    @IBAction func readReservationAction(_ sender: Any) {
        guard let url = URL(string: "http://www.skybarbeirut.com") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if let nav = self.navigationController{
            nav.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func plusAction(_ sender: Any) {
        
        let addFactor = 2//reservationType == 2 ? 2 : 1
        guestCount += addFactor
        self.guestNumberLbl.text = "\(guestCount)"
        if(guestCount>1){
            enableMinusButton()
        }
        
        if(reservationType == 1){
            if(guestCount > self.maximumLimit){
                tableMode()
                maxLbl.text = "The reservation has become a table booking"
            }
        }else if(guestCount >= self.maximumLimit){
            disablePlusButton()
        }
       
    }
    
    @IBAction func minusAction(_ sender: Any) {
        let addFactor = 2//reservationType == 2 ? 2 : 1
        guestCount -= addFactor
        enablePlusButton()
        self.guestNumberLbl.text = "\(guestCount)"
        if(guestCount == self.minimumLimit){
            disableMinusButton()
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
        
        setReservationConfiguration()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setInfo()
        
        if editEvent{
            self.cancelBtn.isHidden = false
            self.modifyBtn.isHidden = false
            self.reserveBtn.isHidden = true
        }else{
            self.cancelBtn.isHidden = true
            self.modifyBtn.isHidden = true
            self.reserveBtn.isHidden = false
        }
    }

    func setReservationConfiguration(){
        
        self.guestNumberLbl.text = "\(guestCount)"
        enablePlusButton()
        
        if !editEvent{
            disableMinusButton()
        }else{
            enableMinusButton()
        }
        
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
                    
                    if !self.editEvent{
                        self.guestCount = self.minimumLimit
                        OperationQueue.main.addOperation({
                            self.guestNumberLbl.text = "\(self.guestCount)"
                            //self.maxLbl.text = "You can reserve up to \(self.maximumLimit) people"
                        })
                    }
                        
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
    
    
    func showReservationPopup(){
        
        var typStr = "Table"
        if reservationType == 1{
            typStr = "Bar"
        }
        
        self.reservationNumberLbl.text = "\(typStr) Reservation for \(guestNumberLbl.text!)"
        
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
    
    @IBAction func hidePopup(_ sender: Any) {
        reservationPopupView.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableMode(){
        self.minimumLimit = self.reservationRules.tableMinimumNumberOfPeople
        self.maximumLimit = self.reservationRules.tableMaximumNumberOfPeople
        tableUIUpdate()
    }
    
    @IBAction func tableAction(_ sender: Any) {
        tableMode()
        guestCount = self.minimumLimit
        self.guestNumberLbl.text = "\(self.guestCount)"
        disableMinusButton()
        enablePlusButton()
        
        maxLbl.text = "All reservations at the bar above \(self.reservationRules.barMaximumNumberOfPeople) people are switched to table bookings"
    }
    
    func tableUIUpdate(){
        reservationType = 2
        barBtn.tag = 0
        setGradientBgToButton(btn: barBtn)
        tableBtn.tag = 11
        setGradientBgToButton(btn: tableBtn)
    }
    
    func barUIUpdate(){
        reservationType = 1
        barBtn.tag = 11
        setGradientBgToButton(btn: barBtn)
        tableBtn.tag = 0
        setGradientBgToButton(btn: tableBtn)
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
    
    @IBAction func barAction(_ sender: Any) {
        self.minimumLimit = self.reservationRules.barMinimumNumberOfPeople
        self.maximumLimit = self.reservationRules.barMaximumNumberOfPeople
        //self.maxLbl.text = "You can reserve up to \(self.maximumLimit) people"
        barUIUpdate()
        
        guestCount = self.minimumLimit
        self.guestNumberLbl.text = "\(self.guestCount)"
        disableMinusButton()
        enablePlusButton()
        maxLbl.text = "Every bar stool fits 2 people"
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
    
    func setInfo(){
        
        if let event = event{

            titleLbl.text = event.name
            
            if let reservation = event.reservationInfo{
                if reservationType == reservation.reservationTypeID{
                    barUIUpdate()
                }else{
                    tableUIUpdate()
                }

                if let count = reservation.numberOfGuests{
                    guestCount = count
                    self.guestNumberLbl.text = "\(guestCount)"
                }
            
            }
            else{
                barUIUpdate()
            }

            descriptionLbl.text = event.description
            doorOpenLbl.text = "Doors open at "
            if let doorOpen = event.doorOpen{
                doorOpenLbl.text! += "\(doorOpen)"
            }

            if let image = event.eventImage{
                self.getImage(key:image)
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
            
            if reservationType == reservation.reservationTypeID{
                barUIUpdate()
            }else{
                tableUIUpdate()
            }
            
            if let count = reservation.numberOfGuests{
                guestCount = count
                self.guestNumberLbl.text = "\(guestCount)"
            }
            
            
            if let desc = reservation.description{
                descriptionLbl.text = desc
            }

            if let key = reservation.eventImage{
                self.getImage(key:key)
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
    
    
    func getImage(key:String){
        self.loader.startAnimating()
        ServiceInterface.resizeImage(imageKey: key,width:Float(self.imageView.getWidth()),height:Float(self.imageView.getHeight()), handler: { (success, result) in
            OperationQueue.main.addOperation {
                self.loader.stopAnimating()
                if success {
                    if let data = result as? Data{
                        
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toReserveEvent"){
            let cntrl = segue.destination as! ReserveEventController
            cntrl.event = event
        }else{
            if(segue.identifier == "toStep1"){
                let cntrl = segue.destination as! EventControllerStep1
                cntrl.event = event
                cntrl.reservation = reservation
                cntrl.guestCount = guestCount
                cntrl.reservationType = reservationType
            }
        }
    }
    
    @IBAction func reserveEvent(){
        if reservationType == 2{
            self.performSegue(withIdentifier: "toStep1", sender: nil)
        }else{
            GlobalUI.showLoading(self.view)
            let guests = Int(guestNumberLbl.text!)!
            ServiceInterface.reserveEvent(eventID: event.id!, type: reservationType, guests:guests, budget: nil , handler: { (success, result) in
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

}
