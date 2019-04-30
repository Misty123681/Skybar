//
//  BillView.swift
//  Skybar
//
//  Created by Christopher Nassar on 1/6/19.
//  Copyright © 2019 Christopher Nassar. All rights reserved.
//

import UIKit

class BillView: UIView {
    
    @IBOutlet weak var tabOpenLbl: UILabel!
    @IBOutlet weak var discountPercentageLbl: UILabel!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    
    @IBOutlet weak var accessCodeLbl: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var reservationMsgLbl: UILabel!
    //@IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var reservationInVenue: UILabel!
    @IBOutlet weak var currentTabLbl: UILabel!
    
    @IBOutlet weak var discountLbl: UILabel!
    
    var layerCorners:UIView! = nil
    @IBOutlet weak var innerView: UIView!
    var bill:CurrentVisitInfo! = nil
    weak var controller:UIViewController! = nil
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBAction func shareAccessCode(_ sender: Any) {
        let shareAll = ["Please Use \(accessCodeLbl.text!)"]
        let activityViewController = UIActivityViewController(activityItems: shareAll as [Any], applicationActivities: nil)
        controller.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func tabOpenAction(_ sender: Any) {
        if let controller = controller as? HomeController{
            controller.performSegue(withIdentifier: "toInvoice", sender: nil)
        }
    }
    
    func disableAllStars(){
        star1.image = UIImage(named: "stargrey")
        star2.image = UIImage(named: "stargrey")
        star3.image = UIImage(named: "stargrey")
        star4.image = UIImage(named: "stargrey")
        star5.image = UIImage(named: "stargrey")
    }
    
    func starManipulation(value:Int){
        
        switch value {
        case 0:
            disableAllStars()
            break
        case 1:
            disableAllStars()
            star1.image = UIImage(named: "starfill")
            break
        case 2:
            disableAllStars()
            star1.image = UIImage(named: "starfill")
            star2.image = UIImage(named: "starfill")
            break
        case 3:
            disableAllStars()
            star1.image = UIImage(named: "starfill")
            star2.image = UIImage(named: "starfill")
            star3.image = UIImage(named: "starfill")
            break
        case 4:
            disableAllStars()
            star1.image = UIImage(named: "starfill")
            star2.image = UIImage(named: "starfill")
            star3.image = UIImage(named: "starfill")
            star4.image = UIImage(named: "starfill")
            break
        case 5:
            disableAllStars()
            star1.image = UIImage(named: "starfill")
            star2.image = UIImage(named: "starfill")
            star3.image = UIImage(named: "starfill")
            star4.image = UIImage(named: "starfill")
            star5.image = UIImage(named: "starfill")
            break
        default:
            break
        }
    }

    @IBAction func ratingChange(_ sender: Any) {
        setRatingAPI(rating: self.slider!.value)
        starManipulation(value: Int(self.slider!.value))
    }
    
    func setRatingAPI(rating:Float){
        if let id = bill.visitID{
            ServiceInterface.setRating(visitID: id, rating: rating){ (success, result) in
                
                if success {
                    
                }else{
                    
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let _ = layerCorners{
            
        }else{
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
    
    func setInfo(bill:CurrentVisitInfo,eventDate:String?,discount:Float,controller:UIViewController){
        self.controller = controller
        self.bill = bill
        
        if let tabStatusClosed = bill.isTabClosed{
            if tabStatusClosed{
                tabOpenLbl.text = "Your tab is closed"
            }
        }
        if let eventDate = eventDate{
            if let date = Date(jsonDate: eventDate){
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "MMM dd"
                
                let monthDayStr = formatter.string(from: date) // string purpose I add here
                monthLbl.text = monthDayStr.uppercased()
                
                formatter.dateFormat = "EEE"
                let dayStr = formatter.string(from: date)
                dayLbl.text = dayStr.uppercased()
            }
        }
        
        if let code = self.bill.reservationAccessCode{
            accessCodeLbl.text = "Access Code: \(code)"
        }
        
        if let reservation = self.bill.reservedEventInfo{
            if let rating = reservation.rating{
                starManipulation(value: rating)
            }
        }
        
        self.discountPercentageLbl.text = String(format:"%.00f %% Discount Total",discount)
        
        
        if let currentTab = self.bill.yourCurrentTab{
            self.currentTabLbl.text = currentTab.toCurrencyNoPrefix()
        }
        
        if let discount = self.bill.totalDiscountValue{
            self.discountLbl.text = discount.toCurrencyNoPrefix()
        }
        
//        if let name = self.bill["TodayEventName"] as? String{
//            self.eventNameLbl.text = name
//        }
        
        if let reservationMsg = self.bill.reservation{
            self.reservationMsgLbl.text = reservationMsg
        }
        
        if let inVenue = self.bill.reservationInVenue{
            self.reservationInVenue.text = "| \(inVenue) in venue"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tap1Action))
        star1.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(tap2Action))
        star2.addGestureRecognizer(tap2)
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(tap3Action))
        star3.addGestureRecognizer(tap3)
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(tap4Action))
        star4.addGestureRecognizer(tap4)
        
        let tap5 = UITapGestureRecognizer(target: self, action: #selector(tap5Action))
        star5.addGestureRecognizer(tap5)
    }
    
    @objc func tap1Action(){
        starManipulation(value: 1)
    }
    
    @objc func tap2Action(){
        starManipulation(value: 2)
    }
    
    @objc func tap3Action(){
        starManipulation(value: 3)
    }
    
    @objc func tap4Action(){
        starManipulation(value: 4)
    }
    
    @objc func tap5Action(){
        starManipulation(value: 5)
    }

}