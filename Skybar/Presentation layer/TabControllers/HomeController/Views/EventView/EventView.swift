//
//  EventView.swift
//  Skybar
//
//  Created by Christopher Nassar on 8/3/18.
//  Copyright © 2018 Christopher Nassar. All rights reserved.
//

import UIKit

class EventView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    var layerCorners:UIView! = nil
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    var event:Event! = nil
    weak var controller:UIViewController! = nil
    
    @IBOutlet weak var reserveLbl: UILabel!
    @IBOutlet weak var reserveIcon: UIImageView!
    
    @IBOutlet weak var reserveBtn: UIButton!
    var shareLink = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    @IBAction func shareAction(_ sender: Any) {
        if shareLink.isEmpty{
            if let name = self.event.name, let description = self.event.description{
                let shareAll = ["\(name) \(description)"]
                let activityViewController = UIActivityViewController(activityItems: shareAll as [Any], applicationActivities: nil)
                controller.present(activityViewController, animated: true, completion: nil)
            }
        }else{
            let shareAll = [shareLink]
            let activityViewController = UIActivityViewController(activityItems: shareAll as [Any], applicationActivities: nil)
            controller.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func reserveAction(_ sender: Any) {
        if let controller = controller as? ReserveController{
            controller.selectEvent(info: event)
        }else if let controller = controller as? HomeController{
            controller.toEventController(event: event)
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
    
    func getShareLink(){
        ServiceInterface.getShareLink(eventID: event.id!) { (success, result) in
            if success{
                if let result = result as? String{
                    self.shareLink = result
                }
            }
        }
    }
    
    func setInfo(event:Event,controller:UIViewController){
        
        self.controller = controller
        self.event = event

        getShareLink()
        titleLbl.text = self.event.name
        descriptionLbl.text = self.event.description
        if let image = self.event.eventImage{
            self.getImage(key:image)
        }
        
//        if self.event.booked ?? false{
//            self.reserveIcon.image = UIImage(named: "confirmed_event")
//            self.reserveLbl.text = "Confirmed"
//            self.reserveLbl.textColor = UIColor(red: 0.13, green: 0.64, blue: 0, alpha: 1)
//            self.reserveBtn.isUserInteractionEnabled = false
//        }else{
//            self.reserveIcon.image = UIImage(named: "reserve_Event")
//            self.reserveLbl.text = "Reserve"
//            self.reserveLbl.textColor = UIColor(red: 0.08, green: 0.34, blue: 0.8, alpha: 1)
//            self.reserveBtn.isUserInteractionEnabled = true
//        }
        
//        if let info = event.reservationInfo{
//            if let statusID = info.reservationStatusID{
//                if let status = ReservationStatus(rawValue: statusID){
//                    switch status{
//                    case .Approved:
//                        self.reserveIcon.image = UIImage(named: "confirmed_event")
//                        self.reserveLbl.text = "Confirmed"
//                        self.reserveLbl.textColor = UIColor(red: 0.13, green: 0.64, blue: 0, alpha: 1)
//                        self.reserveBtn.isUserInteractionEnabled = false
//                    default:
//                        break
//                    }
//
//                }
//            }
//        }
        
        if let info = event.reservationInfo{
            if let typeName = info.reservationStatusTypeName{
                self.reserveLbl.text = typeName
            }
            
            if let statusID = info.reservationStatusID{
                if let status = ReservationStatus(rawValue: statusID){
                    switch status{
                    case .Rejected:
                        self.reserveLbl.textColor = UIColor.init(red: 241.0/255.0, green: 50.0/255.0, blue: 67.0/255.0, alpha: 1)
                    case .Pending:
                        self.reserveLbl.textColor = .orange
                    case .Approved:
                        self.reserveIcon.image = UIImage(named: "confirmed_event")
                        self.reserveLbl.textColor = UIColor(red: 0.13, green: 0.64, blue: 0, alpha: 1)
                    default:
                        break
                    }

                }
            }
        }
        
        
        if let eventDate = self.event.eventDate{
            if let date = Date(jsonDate: eventDate){
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "MMM dd"
                
                let monthDayStr = formatter.string(from: date) // string purpose I add here
                monthLbl.text = monthDayStr.uppercased()
               
                formatter.dateFormat = "EEE"
                let dayStr = formatter.string(from: date) // string purpose I add here
                dayLbl.text = dayStr.uppercased()
            }
        }
    }
    
    
    func getImage(key:String){
        self.loader.startAnimating()
        ServiceInterface.resizeImage(imageKey: key,width: Float(imageView.getWidth()),height: Float(imageView.getHeight()), handler: { (success, result) in
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

}
